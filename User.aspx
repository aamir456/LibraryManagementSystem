<%@ Page Title="" Language="C#" MasterPageFile="~/MainSite.Master" AutoEventWireup="true" CodeBehind="User.aspx.cs" Inherits="LibraryManagementSystem.User" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function () {
            LoadData(0);
            $("#Information").addClass('active');
        })
        function LoadData() {
            var valueobject = {};
            valueobject['OpCode'] = 1;
            valueobject['MemberID'] = <%=Session["UserID"]%>;
            GetDataGrid("1", FillGrid, valueobject, "SPR_User");

        }
        function FillGrid(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var table = xml.find("Table");
            var tbl = $("#demo-datatables-fixedheader-1").DataTable();
            var count = 0;
            tbl.clear();
            if (table.length > 0) {
                table.each(function () {
                    count += 1;
                    var TableRow = $(this);
                    tbl.row.add([
                        count,
                        TableRow.find("FullName").text(),
                        TableRow.find("Name").text(),
                        TableRow.find("IssueDate").text(),
                        TableRow.find("ReturnDate").text()
                    ]);
                    tbl.draw(false);
                });
            }
            else {
                tbl.draw(false);
            }
        }
        function LoadRepeator(response) {
            if (response.d == "") {
                LoadData(0);
            }
            else {
                alert(response.d);
            }
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
                            <h3 style="float:left">User Information</h3>
                        </div>
                        <div class="card-body">
                            <asp:Label runat="server" ID="Label1"></asp:Label>
                           <table id="demo-datatables-fixedheader-1" class="table table-hover table-striped table-nowrap dataTable" cellspacing="0" width="100%" data-page-length="100">
                        <thead>
                            <tr>
                                <th>Sr. No.</th>
                                <th>Member Name</th>
                                <th>Book Name</th>
                                <th>Issued Date</th>
                                <th>Returned Date</th>
                            </tr>
                        </thead>
                        <tbody>   
                        </tbody>
                    </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
