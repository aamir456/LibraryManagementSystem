<%@ Page Title="" Language="C#" MasterPageFile="~/MainSite.Master" AutoEventWireup="true" CodeBehind="Report.aspx.cs" Inherits="LibraryManagementSystem.Report" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        function PrintReport(type) {
            var fromdate = '';
            var Todate = '';
            if ($("#<%=TxtIssueDate.ClientID%>").val()!="") {
                fromdate= ([$("#<%=TxtIssueDate.ClientID%>").val().split("/")[1], $("#<%=TxtIssueDate.ClientID%>").val().split("/")[0], $("#<%=TxtIssueDate.ClientID%>").val().split("/")[2]]).join("/");
            }
            if ($("#<%=TxtReturnDate.ClientID%>").val() != ""){
                Todate =([$("#<%=TxtReturnDate.ClientID%>").val().split("/")[1], $("#<%=TxtReturnDate.ClientID%>").val().split("/")[0], $("#<%=TxtReturnDate.ClientID%>").val().split("/")[2]]).join("/");
            }
            window.open("BookReport.aspx?From=" + fromdate + "&To=" + Todate+"&RpTypeid=" + type);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="layout-content">
        <div class="layout-content-body">
            <div class="title-bar">
            </div>
            <div class="row gutter-xs">
                <div class="col-xs-12">
                    <div class="card">
                          <div class="card-header">
                            <h3 style="float:left">Book Issue Report</h3>
                        </div>
                         <div class="card-body">
                              <div class="row">
                        <div class="col-lg-2 col-md-2 col-sm-12">
                            <label class="txtwhite">From Date:</label>
                            <asp:TextBox runat="server" ID="TxtIssueDate" placeholder="From Date" autocomplete="off" data-provide="datepicker" data-date-clear-btn="true" data-date-today-highlight="true" data-date-format="dd/mm/yyyy" data-date-autoclose="true" CssClass="form-control clear"></asp:TextBox>
                        </div>
                        <div class="col-lg-2 col-md-2 col-sm-12">
                        <label class="txtwhite">To Date:</label>
                        <asp:TextBox runat="server" ID="TxtReturnDate" placeholder="To Date" autocomplete="off" data-provide="datepicker" data-date-clear-btn="true" data-date-today-highlight="true" data-date-format="dd/mm/yyyy" data-date-autoclose="true" CssClass="form-control clear"></asp:TextBox>
                        </div>
                                   <div class="col-lg-2 col-md-1 col-sm-12">
                                   <div class="form-group">
                            <button type="button" class="btn btn-primary"  style="float:right;margin-top: 25px;" onclick="PrintReport(2)">Print Issue</button>
                              </div>
                              </div>
                                  <div class="col-lg-2 col-md-1 col-sm-12">
                                   <div class="form-group">
                            <button type="button" class="btn btn-primary"  style="float:right;margin-top: 25px;" onclick="PrintReport(3)">Print Receive</button>
                              </div>
                              </div>
                                  </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
