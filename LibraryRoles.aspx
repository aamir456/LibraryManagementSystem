<%@ Page Title="" Language="C#" MasterPageFile="~/MainSite.Master" AutoEventWireup="true" CodeBehind="LibraryRoles.aspx.cs" Inherits="LibraryManagementSystem.LibraryRoles" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function () {
            LoadData(0);
            $("#Role").addClass('active');
            clearall();
        })
        function clearall() {
            $('.clear').val("");
            $("#ContentPlaceHolder1_hdnRoleID").val("");
        }
        function InsertData() {
            if (ValidateTextBox($("#TxtRoleName"), 'Role Name canot be NULL')) {
                var valueobject = {};
                if ($("#ContentPlaceHolder1_hdnRoleID").val() != "") {
                    valueobject['OpCode'] = 3;
                    valueobject['RoleID'] = $("#ContentPlaceHolder1_hdnRoleID").val();
                }
                else {
                    valueobject['OpCode'] = 1;
                }
                valueobject['RoleName'] = $("#TxtRoleName").val().trim();
            }
            GetDataGrid("-1", LoadRepeator, valueobject, "SPR_Roles");
        }
        function LoadData(record) {
            var valueobject = {};
            if (record > 0) {
                valueobject['OpCode'] = 2;
                valueobject['RoleID'] = record;
                GetDataGrid("1", FillEditGrid, valueobject, "SPR_Roles");
            }
            else {
                valueobject['OpCode'] = 2;
                GetDataGrid("1", FillGrid, valueobject, "SPR_Roles");
            }
        }
        function FillEditGrid(response) {
            SetModelDisplay("modalFlipInY", "show")
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var DataTable = xml.find("Table");
            DataTable.each(function () {
                var TableRow = $(this);
                $("#ContentPlaceHolder1_hdnRoleID").val(TableRow.find("RoleID").text());
                $("#TxtRoleName").val(TableRow.find("RoleName").text());
            })
        }
        function FillGrid(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var TABLE = xml.find("Table");
            var table = $("#demo-datatables-fixedheader-1").DataTable();
            var count = 0;
            table.clear();
            if (TABLE.length > 0) {
                TABLE.each(function () {
                    var TableRow = $(this);
                    count += 1;
                    table.row.add([
                        count,
                        TableRow.find("RoleName").text(),
                        '<a href="#" id ="btnedit" onclick="LoadData(' + TableRow.find("RoleID").text() + ')" + class="icon icon-pencil" style="color:black"</a>&ensp; | &ensp;' +
                        '<a href="#" id="btndelete" onclick="DeleteData(' + TableRow.find("RoleID").text() + ')" + class="icon icon-trash" style="color:red" </a>'
                    ]);
                    table.draw(false);
                });
            }
            else {
                table.draw(false);
            }
        }
        function DeleteData(RoleID) {
            var v = confirm('Sure');
            if (v===true) {
                var valueobject = {};
                valueobject['OpCode'] = 4;
                valueobject['RoleID'] = RoleID;

            }
            GetDataGrid("-1", LoadRepeator, valueobject, "SPR_Roles");
        }
        function LoadRepeator(response) {
            if (response.d == "") {
                SetModelDisplay("modalFlipInY", "hide");
                LoadData(0);
                clearall();
                $("#ContentPlaceHolder1_hdnRoleID").val("");
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
                            <h3 style="float:left">Roles Record</h3>
                              <div class="form-group">
                            <button type="button" class="btn btn-primary clearall"  style="float:right;margin-top: 9px;"  data-toggle="modal" data-target="#modalFlipInY">Add New</button>
                              </div>
                        </div>
                        <div class="card-body">
                            <asp:Label runat="server" ID="Label1"></asp:Label>
                           <table id="demo-datatables-fixedheader-1" class="table table-hover table-striped table-nowrap dataTable" cellspacing="0" width="100%" data-page-length="100">
                        <thead>
                            <tr>
                                <th>Sr. No.</th>
                                <th>Role Name</th>
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
                    <h3 class="txtwhite">ADD/Edit Library Roles</h3>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <asp:HiddenField runat="server" ID="hdnRoleID" />
                            <label class="txtwhite">Role Name:</label>
                             <input id="TxtRoleName" type="text" placeholder="Role Name" class="form-control clearall" />
                        </div>    
                    </div>
                </div>
                <div class="modal-footer">
                    <div class="m-t-lg">
                        <button class="btn btn-success" type="button" onclick="InsertData();">Save</button>
                        <button class="btn btn-default" data-dismiss="modal" type="button" onclick="clearall();">Cancel</button>
                    </div>
                </div>
                 </div>
            </div>
        </div>
</asp:Content>
