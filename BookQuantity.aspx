<%@ Page Title="" Language="C#" MasterPageFile="~/MainSite.Master" AutoEventWireup="true" CodeBehind="BookQuantity.aspx.cs" Inherits="LibraryManagementSystem.BookQuantity" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function(){
            loadata(0);
            $("#Quantity").addClass('active');
            fillDropDown();
        })
        function clearAll() {
            $('.cleartext').val("");
            $("#ContentPlaceHolder1_hdnBookQuantityID").val("");
        }
        function loadata(record) {
            var valueobject = {};
            if (record > 0) {
                valueobject['OpCode'] = 2;
                valueobject['BookQID'] = record;
                GetDataGrid("1", FillEditGrid, valueobject, "SPR_BookQuantity");
            }
            else {
                valueobject['OpCode'] = 2;
                GetDataGrid("1", fillgrid, valueobject, "SPR_BookQuantity");
            }
        }
        function insertdata() {
            if (ValidateTextBox($("#TxtTotalBook"), 'Book Debit canot be null') && ValidateTextBox($("#TxtRemainingBook"), 'Book Credit canot be null')) {
                var valueobject = {};
                if ($("#ContentPlaceHolder1_hdnBookQuantityID").val() != "") {
                    valueobject['OpCode'] = 3;
                    valueobject['BookQID'] = $("#ContentPlaceHolder1_hdnBookQuantityID").val();
                }
                else {
                    valueobject['OpCode'] = 1;
                }
                //valueobject['BookID'] = $("#TxtBookID").val().trim();
                valueobject['BookID'] = $("#<%=ddlBookID.ClientID%> option:selected").val();
                valueobject['TotalBooks'] = $("#TxtTotalBook").val().trim();
                valueobject['RemainingBooks'] = $("#TxtRemainingBook").val().trim();
                GetDataGrid("-1", loadrepeator, valueobject, "SPR_BookQuantity");
            }
        }
        function fillDropDown() {
            var valueObject = {};
            valueObject['OpCode'] = 5;
            GetDataGrid("1", FillDropDownGrid, valueObject, "SPR_BookQuantity");
        }
        function FillDropDownGrid(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var TableData = xml.find("Table");
            $("#ContentPlaceHolder1_ddlBookID").empty();
            TableData.each(function () {
                var TableRow = $(this);
                $("#ContentPlaceHolder1_ddlBookID").append('<option value="' + TableRow.find("BookID").text() + '">' + TableRow.find("Name").text() + '</option>');
            })
            
        }
        function FillEditGrid(response) {
            SetModelDisplay("modalFlipInY","show")
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var DataTable = xml.find("Table");
            DataTable.each(function() {
                var Tablerow = $(this);
                $("#ContentPlaceHolder1_hdnBookQuantityID").val(Tablerow.find("BookQID").text());
                $("#ContentPlaceHolder1_ddlBookID").val(Tablerow.find("BookID").text());
                $("#TxtTotalBook").val(Tablerow.find("TotalBooks").text());
                $("#TxtRemainingBook").val(Tablerow.find("RemainingBooks").text());
            })
        }
        function fillgrid(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var table = xml.find("Table");
            var tbl = $("#demo-datatables-fixedheader-1").DataTable();
            tbl.clear();
            count = 0;
            if (table.length > 0) {
                table.each(function () {
                    var TableRow = $(this);
                    count += 1;
                    tbl.row.add([
                        count,
                        TableRow.find("Name").text(),
                        TableRow.find("TotalBooks").text(),
                        TableRow.find("RemainingBooks").text()
                        , '<a href="#" id="btnedit" onclick="loadata(' + TableRow.find("BookQID").text() + ')" + class="icon icon-pencil" style="color:black"</a>&ensp;| &ensp;' +
                        '<a href="#" id="btndelete" onclick="deletedata(' + TableRow.find("BookQID").text() + ')" + class="icon icon-trash" style="color:red" </a>'


                    ]);
                    tbl.draw(false);
                });
            }
            else {
                tbl.draw(false);
            }

        }
        
        function loadrepeator(response) {
            if (response.d == "") {
                SetModelDisplay("modalFlipInY", 'hide')
                loadata(0);
                clearAll();
            }
            else {
                alert(response.d);
            }
        }
        function deletedata(BookQID) {
            var v = confirm('Sure');
            if (v === true) {
                var valueobject = {};
                valueobject['OpCode'] = 4;
                valueobject['BookQID'] = BookQID;
                GetDataGrid("-1", loadrepeator, valueobject, "SPR_BookQuantity");
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
                            <h3 style="float:left">Quantity Record</h3>
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
                                <th>BookName</th>
                                <th>Total Books</th>
                                <th>Remaining Books</th>
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
                    <h3 class="txtwhite">ADD/Edit Book Quantity</h3>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12">
                             <asp:HiddenField runat="server" ID="hdnBookQuantityID" />
                            <asp:HiddenField runat="server" ID="hdnBookID" />
                            <label class="txtwhite">Book:</label>
                            <asp:DropDownList ID="ddlBookID" runat="server" CssClass="form-control" DataTextField="BookQuantity" DataValueField="BookID"></asp:DropDownList>
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">Total Books:</label>
                            <input id="TxtTotalBook" type="text" placeholder="Total Book" class="form-control cleartext" />
                        </div>                        
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">Remaining Books:</label>
                            <input id="TxtRemainingBook" type="text" placeholder="Remaining Book" class="form-control cleartext" />
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
