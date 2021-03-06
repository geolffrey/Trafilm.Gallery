﻿//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: BaseMetadataPage.cs
//Version: 20170113

using Metadata.CXML;
using Trafilm.Metadata;
using Trafilm.Metadata.Models;

using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Linq;
using System;

namespace Trafilm.Gallery
{

  public abstract class BaseMetadataPage : System.Web.UI.Page
  {

    #region --- Fields ---

    protected ICXMLMetadataStorage<IFilm> filmStorage;
    protected ICXMLMetadataStorage<IConversation> conversationStorage;
    protected ICXMLMetadataStorage<IL3STinstance> l3STinstanceStorage;
    protected ICXMLMetadataStorage<IL3TTinstance> l3TTinstanceStorage;

    #endregion

    #region --- Methods ---

    #region Authorization

    protected bool IsUserAllowedToRename(string itemType) //not using itemType currently, allowing only Administrators to rename items (change their partial id)
    {
      return (Request.IsAuthenticated &&
              User.IsInRole("Administrators"));
    }

    protected bool IsUserAllowedToSave(string itemType)
    {
      return (Request.IsAuthenticated &&
              (User.IsInRole("Administrators") ||
               User.IsInRole("MetadataEditors") ||
               User.IsInRole("MetadataEditors_" + itemType)
              ));
    }

    protected bool IsUserAllowedToViewVideo()
    {
      return Request.IsAuthenticated;
    }

    protected bool IsUserAllowedToUploadConversationL1video()
    {
      return (Request.IsAuthenticated &&
              (User.IsInRole("Administrators") ||
               User.IsInRole("MetadataEditors") ||
               User.IsInRole("MetadataEditors_L3STinstance")
              ));
    }

    protected bool IsUserAllowedToUploadConversationL2video()
    {
      return (Request.IsAuthenticated &&
              (User.IsInRole("Administrators") ||
               User.IsInRole("MetadataEditors") ||
               User.IsInRole("MetadataEditors_L3TTinstance")
              ));
    }

    #endregion

    #region Create

    public void CreateFilm(string filmId, IFilm metadata = null) //don't return IFilm to avoid loading a .CXML file if already exists
    {
      if (filmStorage.ContainsKey(filmId))
        return;

      if (metadata == null)
      {
        metadata = new Film();
        metadata.Clear();
      }
      else
        metadata.ClearCalculated();

      metadata.Title = filmId;
      metadata.ReferenceId = filmId;

      filmStorage[filmId] = metadata;
    }

    public void CreateConversation(string filmId, string conversationId, IConversation metadata = null) //don't return IConversation to avoid loading a .CXML file if already exists
    {
      if (conversationStorage.ContainsKey(conversationId))
        return;

      if (metadata == null)
      {
        metadata = new Conversation();
        metadata.Clear();
        metadata.FilmReferenceId = filmId;
      }
      else
        metadata.ClearCalculated();

      metadata.Title = conversationId;
      metadata.ReferenceId = conversationId;

      conversationStorage[conversationId] = metadata;
    }

    public void CreateL3STinstance(string filmId, string conversationId, string L3STinstanceId, IL3STinstance metadata = null) //don't return IL3STinstance to avoid loading a .CXML file if already exists
    {
      if (l3STinstanceStorage.ContainsKey(L3STinstanceId))
        return;

      if (metadata == null)
      {
        metadata = new L3STinstance();
        metadata.Clear();
        metadata.FilmReferenceId = filmId;
        metadata.ConversationReferenceId = conversationId;
      }
      else
        metadata.ClearCalculated();

      metadata.Title = L3STinstanceId;
      metadata.ReferenceId = L3STinstanceId;

      l3STinstanceStorage[L3STinstanceId] = metadata;
    }

    public void CreateL3TTinstance(string filmId, string conversationId, string l3STinstanceId, string l3TTinstanceId, IL3TTinstance metadata = null) //don't return IL3TTinstance to avoid loading a .CXML file if already exists
    {
      if (l3TTinstanceStorage.ContainsKey(l3TTinstanceId))
        return;

      if (metadata == null)
      {
        metadata = new L3TTinstance();
        metadata.Clear();
        metadata.FilmReferenceId = filmId;
        metadata.ConversationReferenceId = conversationId;
        metadata.L3STinstanceReferenceId = l3STinstanceId;
      }
      else
        metadata.ClearCalculated();

      metadata.Title = l3TTinstanceId;
      metadata.ReferenceId = l3TTinstanceId;

      l3TTinstanceStorage[l3TTinstanceId] = metadata;
    }

    #endregion

    #region Files

    public static string GetConversationL1videoFilename(string conversationId, string l1Language = "")
    {
      return conversationId + ((l1Language != "")? "_" + l1Language : "") + ".mp4";
    }

    public static string GetConversationL2videoFilename(string conversationId, string l2Language, string l2Mode)
    {
      return conversationId + "_" + l2Language + "_" + l2Mode + ".mp4";
    }

    public bool ConversationL1videoExists(string conversationId, string l1Language = "")
    {
      if (conversationId.StartsWith("*")) return false; //filter out "* Please select..." value which causes Server.MapPath to fail
      try
      {
        return File.Exists(Server.MapPath("~/video/" + GetConversationL1videoFilename(conversationId, l1Language))); //using app-root-relative URL (~/) instead of domain-root-relative one (/)
      }
      catch //illegal characters in path
      {
        return false;
      }
    }

    public bool ConversationL2videoExists(string conversationId, string l2Language, string l2Mode)
    {
      if (conversationId.StartsWith("*")) return false; //filter out "* Please select..." value which causes Server.MapPath to fail
      try
      {
        return File.Exists(Server.MapPath("~/video/" + GetConversationL2videoFilename(conversationId, l2Language, l2Mode))); //using app-root-relative URL (~/) instead of domain-root-relative one (/)
      }
      catch //illegal characters in path
      {
        return false;
      }
    }

    #endregion

    #region URI

    public string GetFilmUriHash(string filmId)
    {
      return "film=" + filmId;
    }

    public string GetConversationUriHash(string filmId, string conversationId)
    {
      return GetFilmUriHash(filmId) + "&conversation=" + conversationId;
    }

    public string GetL3STinstanceUriHash(string filmId, string conversationId, string l3STinstanceId)
    {
      return GetConversationUriHash(filmId, conversationId) + "&L3STinstance=" + l3STinstanceId;
    }

    public string GetL3TTinstanceUriHash(string filmId, string conversationId, string l3STinstanceId, string l3TTinstanceId)
    {
      return GetL3STinstanceUriHash(filmId, conversationId, l3STinstanceId) + "&L3TTinstance=" + l3TTinstanceId;
    }

    public Uri GetFilmUri(string filmId)
    {
      return new Uri("http://gallery.trafilm.net/film/metadata/?" + GetFilmUriHash(filmId));
    }

    public Uri GetConversationUri(string filmId, string conversationId)
    {
      return new Uri("http://gallery.trafilm.net/conversation/metadata/?" + GetConversationUriHash(filmId, conversationId));
    }

    public Uri GetL3STinstanceUri(string filmId, string conversationId, string l3STinstanceId)
    {
      return new Uri("http://gallery.trafilm.net/L3STinstance/metadata/?" + GetL3STinstanceUriHash(filmId, conversationId, l3STinstanceId));
    }

    public Uri GetL3TTinstanceUri(string filmId, string conversationId, string l3STinstanceId, string l3TTinstanceId)
    {
      return new Uri("http://gallery.trafilm.net/L3TTinstance/metadata/?" + GetL3TTinstanceUriHash(filmId, conversationId, l3STinstanceId, l3TTinstanceId));
    }

    public Uri GetVideoUri(string file)
    {
      return new Uri("http://gallery.trafilm.net/video/" + file);
    }

    public Uri GetConversationL1videoUri(string conversationId, string l1Language = "")
    {
      return GetVideoUri(GetConversationL1videoFilename(conversationId, l1Language));
    }

    public Uri GetConversationL2videoUri(string conversationId, string l2Language, string l2Mode)
    {
      return GetVideoUri(GetConversationL2videoFilename(conversationId, l2Language, l2Mode));
    }

    #endregion

    #region Update UI

    public void UpdateRepeater(Repeater repeater, object data)
    {
      repeater.DataSource = data;
      repeater.DataBind();
    }

    public void UpdateList(ListControl list, ICollection<string> keys, string selectedValue = null, bool isQueryStringItem = false)
    {
      list.DataSource = null;
      list.DataBind(); //this seems to be needed

      list.DataSource = new[] { "* Please select..." }.Concat(keys);
      list.SelectedIndex = 0;
      list.DataBind(); //must call this

      if (selectedValue != null)
        if (isQueryStringItem)
        {
          if (Request.QueryString[selectedValue] != null)
            list.SelectedValue = Request.QueryString[selectedValue];
        }
        else
          list.SelectedValue = selectedValue;
    }

    public void UpdateFilmsList(ListControl list, string selectedValue = null, bool isQueryStringItem = false)
    {
      UpdateList(list, filmStorage.Keys, selectedValue, isQueryStringItem);
    }

    public void UpdateConversationsList(ListControl list, string selectedValue = null, bool isQueryStringItem = false)
    {
      UpdateList(list, conversationStorage.Keys, selectedValue, isQueryStringItem);
    }

    public void UpdateL3STinstancesList(ListControl list, string selectedValue = null, bool isQueryStringItem = false)
    {
      UpdateList(list, l3STinstanceStorage.Keys, selectedValue, isQueryStringItem);
    }

    public void UpdateL3TTinstancesList(ListControl list, string selectedValue = null, bool isQueryStringItem = false)
    {
      UpdateList(list, l3TTinstanceStorage.Keys, selectedValue, isQueryStringItem);
    }
   
    #endregion

    #region Save

    protected void SaveCollection(string cxmlFilename, string collectionTitle, IEnumerable<XElement> facetCategories, IEnumerable<ICXMLMetadata> metadataItems)
    {
      Directory.CreateDirectory(Path.GetDirectoryName(Path.GetFullPath(cxmlFilename))); //create any parent directories needed
      using (XmlWriter cxml = XmlWriter.Create(cxmlFilename, CXMLFragmentStorage<ICXMLMetadata, FilmMetadata>.DEFAULT_XML_WRITER_SETTINGS)) //note: FilmMetadata is used there just to access the DEFAULT_XML_WRITER_SETTINGS constant, not instantiating the CXMLFragmentStorage 
        CXMLMetadata.Save(cxml, collectionTitle, facetCategories, metadataItems.ToArray());
    }

    protected string UploadVideo(FileUpload uploadVideo, string filename)
    {
      if (!uploadVideo.HasFile) return "";

      string filepath = Server.MapPath("~/video/" + filename);

      if (Path.GetExtension(uploadVideo.FileName).ToLower() == ".mp4")
        try
        {
          uploadVideo.PostedFile.SaveAs(filepath); //can throw exception
          return "Video uploaded";
        }
        catch(Exception e)
        {
          return "Video upload failed: " + e.Message;
        }
      else
        return "Video upload failed: Only .mp4 files are allowed";
    }
 
    #endregion

    #endregion
  }

}