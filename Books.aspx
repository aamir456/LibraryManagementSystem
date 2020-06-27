<%@ Page Title="" Language="C#" MasterPageFile="~/MainSite.Master" AutoEventWireup="true" CodeBehind="Books.aspx.cs" Inherits="LibraryManagementSystem.Books" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function () {
            loadata(0);
            $("#Books").addClass('active');
        });
        function clearAll() {
            $('.clrtxt').val("");
            $("#ContentPlaceHolder1_hdBookID").val("");
        }
        function PrintReport() {
            window.open("BookReport.aspx?RpTypeid=1");
        }
        function InsertData() {
            if (ValidateTextBox($("#TxtBookName"), 'Book Name canot be null') && ValidateTextBox($("#TxtBookAuthor"), 'Book Author canot be null') && ValidateTextBox($("#TxtBookCode"), 'Book Code canot be null') && ValidateTextBox($("#TxtBookEdition"), 'Book Edition canot be null')) {
                var valueobject = {};
                if ($("#ContentPlaceHolder1_hdBookID").val()!="") {
                    valueobject['OpCode'] = 3;
                    valueobject['BookID'] = $("#ContentPlaceHolder1_hdBookID").val();
                }
                else {
                    valueobject['OpCode'] = 1;
                }
                
                valueobject['Name'] = $("#TxtBookName").val().trim();
                valueobject['Writer'] = $("#TxtBookAuthor").val().trim();
                valueobject['Code'] = $("#TxtBookCode").val().trim();
                valueobject['Edition'] = $("#TxtBookEdition").val().trim();
                GetDataGrid("-1", Loadrepeator, valueobject,"SPR_LibraryBooks");

            }
        }
        function loadata(record) {
            var valueobject = {};
            if (record > 0) {
                valueobject['OpCode'] = 2;
                valueobject['BookID'] = record;
                GetDataGrid("1", FillEditeGrid, valueobject, "SPR_LibraryBooks");
            }
            else {
                valueobject['OpCode'] = 2;
                GetDataGrid("1", FillGrid, valueobject, "SPR_LibraryBooks");
            }
        }
        function FillGrid(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var table = xml.find("Table");
            var Tbl = $('#demo-datatables-fixedheader-1').DataTable();
            Tbl.clear();
            var count = 0;
            if (table.length>0) {            
            table.each(function () {
                var tablerow = $(this);
                count = count + 1;
                Tbl.row.add([
                    count,
                    tablerow.find("Name").text(),
                    tablerow.find("Writer").text(),
                    tablerow.find("Code").text(),
                    tablerow.find("Edition").text()
                    , '<a href="#" id="btnEdit" onclick="loadata(' + tablerow.find("BookID").text() + ')" class="icon icon-pencil" style="color: black"></a>&ensp;| &ensp;'+
                    '<a href="#" id="btnDelete" onclick="deletedata(' + tablerow.find("BookID").text() + ')"  class= "icon icon-trash" style="color: red"></a >'
                ]);
                Tbl.draw(false);
            });
            }
            else {
                Tbl.draw(false);
            }
        } 
        function FillEditeGrid(response) {
            SetModelDisplay("modalFlipInY", 'show')
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var TableData = xml.find("Table");
            TableData.each(function () {
                var TableRow = $(this);
                $("#ContentPlaceHolder1_hdBookID").val(TableRow.find("BookID").text());
                $("#TxtBookName").val(TableRow.find("Name").text());
                $("#TxtBookAuthor").val(TableRow.find("Writer").text());
                $("#TxtBookCode").val(TableRow.find("Code").text());
                $("#TxtBookEdition").val(TableRow.find("Edition").text());
            })
        }
        function deletedata(BookID) {
            var v = confirm('sure');
            if (v === true) {
                var valueobject = {};
                valueobject['OpCode'] = 4;
                valueobject['BookID'] = BookID;
                GetDataGrid("-1", Loadrepeator, valueobject, "SPR_LibraryBooks");
                
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
                            <h3 style="float:left">Book Record</h3>
                              <div class="form-group">
                            <button type="button" class="btn btn-primary" onclick="hide();"style="float:right;margin-top: 9px;"  data-toggle="modal" data-target="#modalFlipInY">Add New</button> 
                              
                        <button id="btnreport" class="btn btn-success" type="button" style="float:right;margin-top: 9px;margin-right: 21px;" onclick="PrintReport()">Book Report</button>
                    </div>
                        </div>
                        <div class="card-body">
                            <asp:Label runat="server" ID="Label1"></asp:Label>
                           <table id="demo-datatables-fixedheader-1" class="table table-hover table-striped table-nowrap dataTable" cellspacing="0" width="100%" data-page-length="100">
                        <thead>
                            <tr>
                                <th>Sr. No.</th>
                                <th>Name</th>
                                <th>Author</th>
                                <th>Book Code</th>
                                <th>Edition</th>
                                <th>Action</th>
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
                    <h3 class="txtwhite">ADD/Edit Book</h3>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <%--<div class="col-<lg-12 col-md-12 col-sm-12">
                           
                            <label class="txtwhite">Enter BookID:</label>
                            <input id="TxtBookID" placeholder="BookID"  class="form-control" />
                        </div> --%>
                        <div class="col-lg-12 col-md-12 col-sm-12">
                             <asp:HiddenField runat="server" ID="hdBookID" />
                            <label class="txtwhite">BookName:</label>
                            <input id="TxtBookName" type="text" placeholder="Book Name" class="form-control clrtxt" />
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">BookAuthor:</label>
                            <input id="TxtBookAuthor" type="text" placeholder="Book Author" class="form-control clrtxt" />
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">BookCode:</label>
                            <input id="TxtBookCode" type="text" placeholder="Book Code" class="form-control clrtxt" />
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">BookEdition:</label>
                            <input id="TxtBookEdition" type="text" placeholder="Book Edition" class="form-control clrtxt" />
                        </div>
                    </div>
                    </div>
                <div class="modal-footer">
                    <div class="m-t-lg">
                        <button class="btn btn-success" type="button" onclick="InsertData();">Save</button>
                        <button class="btn btn-default" data-dismiss="modal" type="button" onclick="clearAll();">Cancel</button>
                    </div>
                </div>
                 </div>
            </div>
        </div>
</asp:Content>
