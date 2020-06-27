<%@ Page Title="" Language="C#" MasterPageFile="~/MainSite.Master" AutoEventWireup="true" CodeBehind="BookReport.aspx.cs" Inherits="LibraryManagementSystem.BookReport" %>
<%@ Register assembly="CrystalDecisions.Web, Version=13.0.3500.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" namespace="CrystalDecisions.Web" tagprefix="CR" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="aspnet_client/system_web/4_0_30319/crystalreportviewers13/js/crviewer/crv.js"></script> 
    <script src="aspnet_client/system_web/2_0_50727/CrystalReportWebFormViewer3/js/print.js"></script> 
    
    <style>

        .singlerow {
            display: -webkit-box;
        }

            .singlerow span {
                display: -webkit-box;
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div class="layout-content-body">
          <div class="row gutter-xs">
            <div class="col-xs-12">
              <div class="card">
                <div class="card-header">
                  <strong>Report</strong>

                </div>
                <div class="card-body">
                   
             <div id="DivError" class="geterror" runat="server">
                    <img src="images/diverror.png" alt="Error" style="width: 30px; height: 30px; vertical-align: middle;" hspace="10" />
                    <asp:Label ID="lblError" runat="server"></asp:Label>
                </div>
                <CR:CrystalReportViewer   ID="vwrReport" runat="server"  HasCrystalLogo="false" 
                                           HasToggleParameterPanelButton="False"  HasDrilldownTabs="False" PrintMode="ActiveX"
                                                  HasPageNavigationButtons="True" HasZoomFactorList="True"    HasDrillUpButton="False" HasToggleGroupTreeButton="false"   PageZoomFactor="100"
                                           ToolPanelView="None"   
                                            AutoDataBind="true"    />
                   </div>
                </div>
              </div>
            </div>
          </div>
</asp:Content>
