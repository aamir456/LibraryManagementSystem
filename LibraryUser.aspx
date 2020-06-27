<%@ Page Title="" Language="C#" MasterPageFile="~/MainSite.Master" AutoEventWireup="true" CodeBehind="LibraryUser.aspx.cs" Inherits="LibraryManagementSystem.LibraryUser" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function () {
            LoadData(0);
            $("#Users").addClass('active');
            FillDropDownRoles();
        })
        function clear() {
            $('.clear').val("");
        }
        function InsertData() {
            if (ValidateTextBox($("#TxtUserName"), 'User Name canot be null') && ValidateTextBox($("#TxtPassword"), 'Password canot be null')) {
                var valueobject = {};
                if ($("#ContentPlaceHolder1_hdnUserID").val()!="") {
                    valueobject['OpCode'] = 3;
                    valueobject['UserID'] = $("#ContentPlaceHolder1_hdnUserID").val();
                }
                else {
                    valueobject['OpCode'] = 1;
                }
                valueobject['FullName'] = $("#TxtFullName").val().trim();
                valueobject['UserName'] = $("#TxtUserName").val().trim();
                valueobject['Password'] = $("#TxtPassword").val().trim();
                valueobject['RoleID'] = $("#<%=ddlRoleID.ClientID%>").val();
                valueobject['ActiveStatus'] = $("#<%=ddlActive.ClientID%> option:selected").val();
            }
            GetDataGrid("-1", LoadRepeator, valueobject, "SPR_LibraryUser");
        }
        function LoadData(record) {
            var valueobject = {};
            if (record > 0) {
                valueobject['OpCode'] = 2;
                valueobject['UserID'] = record;
                GetDataGrid("1", FillEditGrid, valueobject, "SPR_LibraryUser");
            }
            else {
                valueobject['OpCode'] = 2;
                GetDataGrid("1", FillGrid, valueobject, "SPR_LibraryUser");
            }
        }
        function FillEditGrid(response) {
            SetModelDisplay("modalFlipInY", "show");
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var DataTable = xml.find("Table");
            DataTable.each(function () {
                var TableRow = $(this);
                $("#ContentPlaceHolder1_hdnUserID").val(TableRow.find("UserID").text());
                $("#TxtFullName").val(TableRow.find("FullName").text());
                $("#TxtUserName").val(TableRow.find("UserName").text());
                $("#TxtPassword").val(TableRow.find("Password").text());
                $("#ContentPlaceHolder1_ddlRoleID").val(TableRow.find("RoleID").text());
                $("#ContentPlaceHolder1_ddlActive").val(TableRow.find("IsActive").text());
            })
        }
        function FillGrid(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var table = xml.find("Table");
            var tbl = $("#demo-datatables-fixedheader-1").DataTable();
            var count = 0;
            tbl.clear();
           // table.empty();
            if (table.length > 0) {
                table.each(function () {
                    count += 1;
                    var tablerow = $(this);
                    tbl.row.add([
                        count,
                        tablerow.find("FullName").text(),
                        tablerow.find("UserName").text(),
                        tablerow.find("Password").text(),
                        tablerow.find("RoleName").text(),
                        tablerow.find("isActive").text()
                        , '<a href="#" id="btnedit" onclick="LoadData(' + tablerow.find("UserID").text() + ')" + class="icon icon-pencil" style="color:black"</a>&ensp; | &ensp;' +
                        '<a href="#" id="btndelete" onclick="deletedata(' + tablerow.find("UserID").text() +')" + class="icon icon-trash" style="color:red" </a>'
                    ]);
                    tbl.draw(false);
                });
            }
            else {
                tbl.draw(false);
            }
        }
        function deletedata(IssueID) {
            var v = confirm('Sure');
            if (v === true) {
                var valueobject = {};
                valueobject['OpCode'] = 4;
                valueobject['IssueID'] = IssueID;
            }
            GetDataGrid("-1", LoadRepeator, valueobject, "SPR_LibraryUser");
        }
        function FillDropDownRoles() {
            var valueobject = {};
            valueobject['OpCode'] = 5;
            GetDataGrid("1", FillRoleGrid, valueobject, "SPR_LibraryUser");
        }
        function FillRoleGrid(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var table = xml.find("Table");
            $("#ContentPlaceHolder1_ddlRoleID").empty();
            table.each(function () {
                var tablerow = $(this);
                $("#ContentPlaceHolder1_ddlRoleID").append('<option value="' + tablerow.find("RecordID").text() + '">' + tablerow.find("Record").text() + '</option>');
            })
        }
        function LoadRepeator(response) {
            if (response.d == "") {
                SetModelDisplay("modalFlipInY", "hide");
                LoadData(0);
                clear();
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
                            <h3 style="float:left">Users Record</h3>
                              <div class="form-group">
                            <button type="button" class="btn btn-primary" style="float:right;margin-top: 9px;"  data-toggle="modal" data-target="#modalFlipInY">Add New</button> 
                              </div>
                        </div>
                        <div class="card-body">
                            <asp:Label runat="server" ID="Label1"></asp:Label>
                           <table id="demo-datatables-fixedheader-1" class="table table-hover table-striped table-nowrap dataTable" cellspacing="0" width="100%" data-page-length="100">
                        <thead>
                            <tr>
                                <th>Sr. No.</th>
                                <th>Full Name</th>
                                <th>User Name</th>
                                <th>Password</th>
                                <th>Role Name</th>
                                <th>Is Active</th>
                                <th>Action/s</th> 
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
    <div id="modalFlipInY" tabindex="-1" role="dialog" class="modal in">
        <div class="modal-dialog"> 
            <div class="modal-content animated flipInY">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" onclick="">
                        <span aria-hidden="true">×</span>
                        <span class="sr-only">Close</span>
                    </button>
                    <h3 class="txtwhite">ADD/Edit User Information</h3>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <asp:HiddenField runat="server" ID="hdnUserID" />
                            <label class="txtwhite">FullName:</label>
                            <input id="TxtFullName" type="text" placeholder="Full Name" class="form-control clear" />
                        </div>                  
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">User Name:</label>
                            <input id="TxtUserName" type="text" placeholder="User Name" class="form-control clear" />
                        </div                       > 
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">Password:</label>
                            <input id="TxtPassword" type="text" placeholder="Password" class="form-control clear" />
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">Status</label>
                            <asp:DropDownList runat="server" ID="ddlActive" DataValueField="ActiveStatus" CssClass="form-control" DataTextField="ActiveStatus">
                                <asp:ListItem Value="1">Active</asp:ListItem>
                                <asp:ListItem Value="0">Inactive</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">Role</label>
                            <asp:DropDownList ID="ddlRoleID" runat="server" CssClass="form-control" DataTextField="RoleName" DataValueField="RoleID"></asp:DropDownList>
                        </div>
                    </div>
                    </div>
                <div class="modal-footer">
                    <div class="m-t-lg">
                        <button class="btn btn-success" type="button" onclick="InsertData();">Save</button>
                        <button class="btn btn-default" data-dismiss="modal" type="button" onclick="clear();">Cancel</button>
                    </div>
                </div>
                 </div>
            </div>
        </div>

</asp:Content>
