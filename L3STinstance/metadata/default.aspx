﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="Trafilm.Gallery.L3STinstanceMetadataPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: L3STinstance\metadata\default.aspx
Version: 20160606
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Gallery - L3ST-instance Metadata</title>

    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>

    <asp:XmlDataSource ID="xmlL3STlanguageType" runat="server" DataFile="~/metadata/L3STlanguageType.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STconstructedBasedOn" runat="server" DataFile="~/metadata/L3constructedBasedOn.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STaudienceUnderstanding" runat="server" DataFile="~/metadata/L3audienceUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STmessageUnderstanding" runat="server" DataFile="~/metadata/L3messageUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STmeaningDeciphered" runat="server" DataFile="~/metadata/L3meaningDeciphered.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STspeakerPerformance" runat="server" DataFile="~/metadata/L3speakerPerformance.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STmode" runat="server" DataFile="~/metadata/L3mode.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STrepresented" runat="server" DataFile="~/metadata/L3represented.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STrepresentationsOral" runat="server" DataFile="~/metadata/L3representationsOral.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STrepresentationsVisual" runat="server" DataFile="~/metadata/L3representationsVisual.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STfunctions" runat="server" DataFile="~/metadata/L3functions.xml" XPath="Facet/String" />

    <%-- NAVIGATION MENU --%>

    <div class="navigation">
       <a href="../../film/metadata/?film=<%=listFilms.SelectedValue%>">Film Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../conversation/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>">Conversation Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a class="selected" href="../../L3STinstance/metadata/">L3ST-instance Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../L3TTinstance/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>&L3STinstance=<%=listL3STinstances.SelectedValue%>">L3TT-instance Metadata</a>
    </div>

    <%-- INSTRUCTIONS BOX --%>

    <div class="instructions">
      Please fill in the following information for the L3ST-instance of your choice. Select the L3ST-instance from the dropdown list.<br />
      Try to fill the metadata as fully and accurately as possible, as they will be used for searching and filtering L3ST-instances.<br />
      Don't forget to press the SAVE METADATA button. Thank you!
    </div>

    <form id="form1" runat="server">

      <%-- LOGIN STATUS --%>

      <asp:LoginName ID="loginName" runat="server" FormatString="Welcome {0}!" /> [<asp:LoginStatus ID="loginStatus" runat="server"/>]

      <%-- INFO BOX --%>

      <div class="bar">

        <div>
        <div class="label">Select a Film</div>
          <asp:DropDownList ID="listFilms" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listFilms_SelectedIndexChanged" />
        </div>
        
        <asp:Panel runat="server" ID="panelConversationId" Visible="false">
          <div>
            <div class="label">Select a Conversation</div> 
            <asp:DropDownList ID="listConversations" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listConversations_SelectedIndexChanged" />
          </div>

          <asp:Panel runat="server" ID="panelL3STinstanceId" Visible="false">
            <div class="label">Select an L3ST-instance</div> 
            <asp:DropDownList ID="listL3STinstances" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listL3STinstances_SelectedIndexChanged" />

            <div>
              <div class="label">or add new L3ST-instance Id (e.g. <i>Chinese</i> - do not include the Film Id and Conversation Id prefixes)</div>
              <asp:TextBox ID="txtL3STinstance" runat="server" />
              <asp:Button ID="btnAddL3STinstance" runat="server" Text="Add" OnClick="btnAddL3STinstance_Click" />
              &nbsp;
              <asp:CheckBox ID="cbClone" Text="Copy from selected" runat="server" Visible="false" />
            </div>
          </asp:Panel>

        </asp:Panel>

      </div>

      <%-- METADATA INPUT UI --%>

      <asp:Panel ID="panelMetadata" runat="server" Visible="false">

        <%-- ICXMLMetadata--%>

        <div class="question">
          <div class="label">1. L3ST-instance Title (optional)</div>
          <asp:TextBox ID="txtTitle" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">2. L3ST-instance Description (optional)</div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>

        <div class="label">L3ST-instance URL</div>
        <asp:HyperLink ID="linkUrl" runat="server" Target="_blank"/>
    
        <%-- TODO: maybe add image control and upload image action here? %>    


        <%-- ITrafilmMetadata --%>

        <div>
          <span class="label">Info created: </span>
          <asp:Label ID="lblInfoCreated" runat="server" />

          <span class="label"> - Info Updated: </span>
          <asp:Label ID="lblInfoUpdated" runat="server" />
        </div>

        <div class="question">
          <div class="label">3. Transcription </div>
          <div class="tip">Transcription for the specific L3ST-instance (OPTIONAL)</div>
          <asp:TextBox ID="txtTranscription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>

        <div class="question">
          <div class="label">4. Keywords</div>
          <div class="tip">Comma-separated list of keywords to help identify this item (OPTIONAL)</div>
          <asp:TextBox ID="txtKeywords" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">5. Remarks </div>
          <div class="tip">Remarks on the metadata itself (OPTIONAL)</div>
          <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>


        <%-- IL3STinstanceMetadata --%>


        <div class="question">
          <div class="label">6. L3ST-instance Start Time (h:m:s)</div>
          <div class="tip">What part of the film is L3ST in? (i.e. how many minutes and seconds from the start)</div>
          <asp:TextBox ID="txtStartTime" runat="server" Columns="25"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">7. L3ST-instance Duration (h:m:s)</div>
          <div class="tip">How long does L3ST last? (if the L3ST is interrupted by other speech, count total seconds from onset to end of final L3ST-instance)</div>
          <asp:TextBox ID="txtDuration" runat="server" Columns="25"></asp:TextBox>
        </div>


        <div>
          <div class="label">L1 language</div>
          <div class="tip">What language is L1 in?</div>
          <asp:Label ID="lblL1language" runat="server" />
        </div>


        <div class="question">
          <div class="label">8. L3ST language type</div>
          <div class="tip">With L1 as main language (L-main), what type of language is L3ST?</div>
          <asp:DropDownList 
            ID="listL3STlanguageType" runat="server"
            DataSourceID="xmlL3STlanguageType" DataTextField="Title" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">9. L3ST language</div>
          <div class="tip">Which language is L3ST?</div>
          <asp:TextBox ID="txtL3STlanguage" runat="server" Columns="150"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">10. L3ST constructed based on</div>
          <div class="tip">If L3ST is “constructed”, then is based on:</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STconstructedBasedOn" runat="server" 
              DataSourceID="xmlL3STconstructedBasedOn" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">11. L3ST meant to be understood</div>
          <div class="tip">Is L3ST meant to be understood by most of the audience?</div>
          <asp:DropDownList 
            ID="listL3STaudienceUnderstanding" runat="server"
            DataSourceID="xmlL3STaudienceUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">12. L3ST required for understanding</div>
          <div class="tip">Does L3ST carry a meaningful message or one that requires it to be understood?</div>
          <asp:DropDownList 
            ID="listL3STmessageUnderstanding" runat="server"
            DataSourceID="xmlL3STmessageUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">13. L3ST meaning decipherable</div>
          <div class="tip">Can the (pragmatic) meaning of L3ST be deciphered by other means? </div>
          <asp:DropDownList 
            ID="listL3STmeaningDecipherable" runat="server"
            DataSourceID="xmlL3STmeaningDeciphered" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">14. L3ST speaker performance</div>
          <div class="tip">Select speaker’s L3ST proficiency and performance:</div>
          <asp:DropDownList 
            ID="listL3STspeakerPerformance" runat="server"
            DataSourceID="xmlL3STspeakerPerformance" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">15. L3ST mode</div>
          <div class="tip">Mode of L3ST?</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STmode" runat="server" 
              DataSourceID="xmlL3STmode" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">16. L3ST represented</div>
          <div class="tip">There is no L3ST as such, strictly speaking, but rather, it is hinted at through certain "clues" verbally (in the L1) or non-verbally (visually or otherwise)</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STrepresented" runat="server" 
              DataSourceID="xmlL3STrepresented" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question">
          <div class="label">17. L3ST represented: oral</div>
          <div class="tip">If “oral” selected for question on “L3ST represented”, specify how:</div>
          <div class="tip"></div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STrepresentationsOral" runat="server" 
              DataSourceID="xmlL3STrepresentationsOral" DataTextField="Title" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question">
          <div class="label">18. L3ST represented: visual</div>
          <div class="tip">If “visual” selected for question on “L3ST represented”, specify how:</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STrepresentationsVisual" runat="server" 
              DataSourceID="xmlL3STrepresentationsVisual" DataTextField="Value" DataValueField="Value" 
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">19. L3ST functions</div>
          <%-- <div class="tip"></div> --%>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STfunctions" runat="server" 
              DataSourceID="xmlL3STfunctions" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <%-- Calculated from L3TTinstances --%>

        <div>
          <div class="label">Count of L3TT-instances (Calculated)</div>
          <asp:Label ID="lblL3TTinstanceCount" runat="server"></asp:Label>
        </div>    
        
        
        <%-- L3TTinstances list --%>                  

        <asp:Repeater ID="repeaterL3TTinstances" runat="server">
          <HeaderTemplate>
            <div class="label">List of L3TT-instances<div>
          </HeaderTemplate>
          <ItemTemplate>
            <a href="../../L3TTinstance/metadata/?film=<%#Eval("filmId")%>&conversation=<%#Eval("conversationId")%>&L3STinstance=<%#Eval("L3STinstanceId")%>&L3TTinstance=<%#Eval("L3TTinstanceId")%>"><%#Eval("L3TTinstanceId")%></a>&nbsp;&nbsp;
          </ItemTemplate>
        </asp:Repeater>


        <%-- SAVE BUTTON --%>
           
        <div>
          <asp:Button ID="btnSave" runat="server"
            Text="Save metadata"
            Font-Bold="true"
            height="50"
            OnClick="btnSave_Click"
            />
        </div>

        <%-- EXTRA PADDING AT THE END --%>
        <br />
        <br />

      </asp:Panel>
    
    </form>

  </body>

</html>