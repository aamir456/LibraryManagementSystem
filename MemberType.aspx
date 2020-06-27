<%@ Page Title="" Language="C#" MasterPageFile="~/MainSite.Master" AutoEventWireup="true" CodeBehind="MemberType.aspx.cs" Inherits="LibraryManagementSystem.Members" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="js/MyJS.js"></script>
    <script>
        $(document).ready(function () {
            loadata(0);
        });
        function clearAll() {
            $('.cleartext').val("");
            $("#ContentPlaceHolder1_hdnMemberTypeID").val("");
        }
        function insertdata() {
            if (ValidateTextBox($("#TxtMemberType"), 'Member Type canot be null') && ValidateTextBox($("#TxtBookLimit"), 'Book Limit canot be null') && ValidateTextBox($("#TxtDayLimit"), 'Day Limit canot be null')) {
                var valueobject = {};
                if ($("#ContentPlaceHolder1_hdnMemberTypeID").val() != "") {
                    valueobject['OpCode'] = 2;
                    valueobject['MemberTypeID'] = $("#ContentPlaceHolder1_hdnMemberTypeID").val();
                }
                else {
                    valueobject['OpCode'] = 1;

                }
                valueobject['MemeberType'] = $("#TxtMemberType").val().trim();
                valueobject['BookLimit'] = $("#TxtBookLimit").val().trim();
                valueobject['DayLimit'] = $("#TxtDayLimit").val().trim();
                GetDataGrid("-1", Loadrepeator, valueobject, "SPR_MemberType");
            }
        }
        function loadata(record) {
            var valueobject = {};
            if (record > 0) {
                valueobject['OpCode'] = 4;
                valueobject['MemberTypeID'] = record;
                GetDataGrid("1", FillEditeGrid, valueobject, "SPR_MemberType");
            }
            else {
                valueobject['OpCode'] = 4;
                GetDataGrid("1", FillGrid, valueobject,"SPR_MemberType");
            }
        }
        function FillGrid(response) {
            var xmldoc = $.parseXML(response.d);
            var xml = $(xmldoc);
            var Table = xml.find("Table");
            var tbl = $('#demo-datatables-fixedheader-1').DataTable();
            tbl.clear();
            var count = 0;
            if (Table.length > 0) {
                Table.each(function () {
                    var tablerow = $(this);
                    count = count + 1;
                    tbl.row.add([
                        count,
                        tablerow.find("MemeberType").text(),
                        tablerow.find("BookLimit").text(),
                        tablerow.find("DayLimit").text(),
                         '<a href="#" id="btnEdit" onclick="loadata(' + tablerow.find("MemberTypeID").text() + ')" + class="icon icon-pencil" style="color:black"></a>&ensp;| &ensp;' +
                        '<a href="#" id="btndelete" onclick="deletedata(' + tablerow.find("MemberTypeID").text() + ')" + class="icon icon-trash" style="color:red"></a>'
                    ]);
                    tbl.draw(false);
                });
            }
            else {
                tbl.draw(false);
            }
        }
        function FillEditeGrid(response) {
            SetModelDisplay("modalFlipInY", 'show');
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var TableData = xml.find("Table");
            TableData.each(function () {
                var TableRow = $(this);
                $("#ContentPlaceHolder1_hdnMemberTypeID").val(TableRow.find("MemberTypeID").text());
                $("#TxtMemberType").val(TableRow.find("MemeberType").text());
                $("#TxtBookLimit").val(TableRow.find("BookLimit").text());
                $("#TxtDayLimit").val(TableRow.find("DayLimit").text());
            })

        }
        
        function deletedata(MemberTypeID) {
            var d = confirm('Sure');
            if (d===true) {
                var valueobject = {};
                valueobject['OpCode'] = 3;
                valueobject['MemberTypeID'] = MemberTypeID;
                GetDataGrid("-1", Loadrepeator, valueobject, "SPR_MemberType");
            }
        }
        function Loadrepeator(response) {
            if (response.d == "") {
                SetModelDisplay("modalFlipInY", 'hide')
                loadata(0);
                clearAll();
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
                            <h3 style="float:left">Member Type</h3>
                              <div class="form-group">
                            <button type="button" class="btn btn-primary" onclick="hide();"style="float:right;margin-top: 9px;"  data-toggle="modal" data-target="#modalFlipInY">Add New</button> 
                              </div>
                        </div>
                        <div class="card-body">
                            <asp:Label runat="server" ID="Label1"></asp:Label>
                           <table id="demo-datatables-fixedheader-1" class="table table-hover table-striped table-nowrap dataTable" cellspacing="0" width="100%" data-page-length="100">
                        <thead>
                            <tr>
                                <th>Sr. No.</th>
                                <th>Member Type</th>
                                <th>Book Limit</th>
                                <th>Day Limit</th>
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
                    <h3 class="txtwhite">ADD/Edit Member</h3>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12">
                             <asp:HiddenField runat="server" ID="hdnMemberTypeID" />
                            <label class="txtwhite">MemberType:</label>
                            <input id="TxtMemberType" type="text" placeholder="Member Type" class="form-control cleartext" />
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">BookLimit:</label>
                            <input id="TxtBookLimit" type="text" placeholder="Book Limit" class="form-control cleartext" />
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">DayLimit:</label>
                            <input id="TxtDayLimit" type="text" placeholder="Day Limit" class="form-control cleartext" />
                        </div>
                    </div>
                    </div>
                <div class="modal-footer">
                    <div class="m-t-lg">
                        <button class="btn btn-success" type="button" onclick="insertdata();">Save</button>
                        <button class="btn btn-default" data-dismiss="modal" type="button" onclick="clearAll();">Cancel</button>
                    </div>
                </div>
                 </div>
            </div>
        </div>
</asp:Content>
