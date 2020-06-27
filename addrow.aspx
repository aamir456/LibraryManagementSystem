<%@ Page Title="" Language="C#" MasterPageFile="~/MainSite.Master" AutoEventWireup="true" CodeBehind="addrow.aspx.cs" Inherits="LibraryManagementSystem.addrow" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        var Tbl;
        $(document).ready(function () {
            loadata(0);
            Tbl = $('#demo-datatables-fixedheader-1').DataTable();
            LoadDropdownBook();
            AddTwoRows();
        });
        function AddTwoRows() {
            for (var i = 0; i < 2; i++) {
                addrow();
            }
        }
        function calculateColumn() {
            var total1 = 0;
            var total2 = 0;
            $('#demo-datatables-fixedheader-1 tbody tr').each(function () {
                var value1 = parseInt($(".aa",this).val());
                var value2 = parseInt($(".bb", this).val());
                total1 = total1 + value1;
                total2 = total2 + value2;
            });
            if (total1 == total2) {
                return true;
            }
            else {
                alert('Debit amount and Credit amount must be same:');
            }
        }
        function FillDropDownGridBook(response) {
            var xmlDoc = $.parseXML(response.d)
            var xml = $(xmlDoc);
            var Table = xml.find("Table");
            $(".drop").empty();
            Table.each(function () {
                var TableRow = $(this);
                $(".drop").append('<option value="' + TableRow.find("BookID").text() + '">' + TableRow.find("Name").text() + '</option>');
                $(".drop")[1].selectedIndex = 1;
            })
        }
        function LoadDropdownBook() {
            var valueobject = {};
            valueobject['OpCode'] = 5;
            GetDataGrid("1", FillDropDownGridBook, valueobject, "SPR_LibraryBooks");
        }
        function del(VAL) {
            if ((Tbl.data().length) > 2) {
                $('#demo-datatables-fixedheader-1').DataTable().row(VAL.closest('tr')).remove().draw();
            }
            else {
                alert('Rows must br greater than 2');
            }
        }
        function DeleteMaster(MasterID) {
            var v = confirm('sure');
            if (v === true) {
                var valueobject = {};
                valueobject['OpCode'] = 3;
                valueobject['MasterID'] = MasterID;
                GetDataGrid("-1", Loadrepeator, valueobject, "SPR_Rw");
            }
        }
        function DeleteAll(response) {
            var data = {};
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var TableData = xml.find("Table");
            TableData.each(function () {
                var tablerow = $(this);
                var data = tablerow.find("MasterID").text();
                alert(data);
            })
        }
        function addrow() {
            var count = 0;
            var href = '<a href="#" id="btndelete" onclick="del(this)" class="icon icon-trash" style="color:red"</a>';
            if ((Tbl.data().length) > 1) {
                Tbl.row.add([
                    count,
                    '<select id="ddlBookID" Class="form-control drop"></select >',
                    '<input type="text" id="debit" placeholder="Debit Amount" Class="form-control aa">',
                    '<input type="text" id="credit" placeholder="Credit Amount" Class="form-control bb">'
                    , '<a href="#" id ="btnedit" class="icon icon-pencil" style="color: black"</a>&ensp; | &ensp;' +
                    href
                ]);
                Tbl.draw();
                LoadDropdownBook();
            }
            else {
                Tbl.row.add([
                    count,
                     '<select id="ddlBookID" Class="form-control drop"></select >',
                    '<input type="text" id="debit" placeholder="Debit Amount" Class="form-control aa">',
                     '<input type="text" id="credit" placeholder="Credit Amount" Class="form-control bb">'
                    , '<a href="#" id ="btnedit" class="icon icon-pencil" style="color: black"</a>'
                ]);
                Tbl.draw();
                LoadDropdownBook();
            }
        }
        function SaveData() {
            var valueObject = {};
            var Query = '';
            if ((ValidateTextBox($(".aa"), 'Fields canot be null'))) {
                if (calculateColumn() === true) {
                    if ($("#ContentPlaceHolder1_HiddenField1").val() != "") {
                        valueObject['OpCode'] = 5;
                        valueObject['MasterID'] = $("#ContentPlaceHolder1_HiddenField1".val());
                    }
                    else {
                        valueObject['OpCode'] = 1;
                    }
                    $('#demo-datatables-fixedheader-1 tbody tr').each(function () {
                        var tablerow = $(this);
                        Query += '(' + tablerow.find(".drop").val() + ',' + tablerow.find(".aa").val() + ',' + tablerow.find(".bb").val() + ',Amir),';
                    });
                    Query = Query.substring(0, Query.length - 1);
                    valueObject['Query'] = '"' + Query + '"';
                    GetDataGrid("-1", Loadrepeator, valueObject, "SPR_Rw");
                }
            }
           
        }
        function loadata(record) {
            var valueobject = {};
            if (record > 0) {
                valueobject['OpCode'] = 4;
                valueobject['MasterID'] = record;
                GetDataGrid("1", FillEditeGrid, valueobject, "SPR_Rw");
            }
            else {
                valueobject['OpCode'] = 2;
                GetDataGrid("1", FillGrid, valueobject, "SPR_Rw");
            }
        }
        function FillGrid(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var table = xml.find("Table");
            var Tbl = $('#demo-datatables-fixedheader-2').DataTable();
            Tbl.clear();
            var count = 0;
            if (table.length > 0) {
                table.each(function () {
                    var tablerow = $(this);
                    count = count + 1;
                    Tbl.row.add([
                        count,
                        tablerow.find("Name").text()
                        , '<a href="#" id="btnEdit" onclick="loadata(' + tablerow.find("MasterID").text() + ')" class="icon icon-pencil" style="color: black"></a>&ensp;| &ensp;' +
                        '<a href="#" id="btnDelete" onclick="DeleteMaster(' + tablerow.find("MasterID").text() + ')"  class= "icon icon-trash" style="color: red"></a >'
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
            var n = TableData.length;
            for (var i = 0; i < n-2; i++) {
                addrow();
            }
            var table = $("demo-datatables-fixedheader-1").DataTable();
            var count = 0;
            if (TableData.length > 0) {
                TableData.each(function () {
                    count = count + 1;
                    var tablerow = $(this);
                    table.row.add([
                        count,
                        '<select id="ddlBookID"  value ="' + tablerow.find("BookID").text() + '"  Class="form-control drop dropno"' + count + '></select >',
                        '<input type="text" id="debit" value="' + tablerow.find("BookDebit").text()+'"  placeholder="Debit Amount" Class="form-control aa">',
                        '<input type="text" id="credit" value="' + tablerow.find("BookCredit").text()+'" placeholder="Credit Amount" Class="form-control bb">'
                    ]);
                 
                });
            }
            
        }
        
        function Loadrepeator(response) {
            if (response.d == "") {
                loadata(0);
                $("#ContentPlaceHolder1_HiddenField1").val("");
                $(".aa").val("");
                $(".bb").val("");
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
                            <h3 style="float:left">Members Information</h3>
                              <%--<div class="form-group">
                             <label class="txtwhite" hidden id="hdnlbl">BookEdition:</label>
                            <button type="button" class="btn btn-primary" style="float:right;margin-top: 9px;width: 100px;"  data-toggle="modal" data-target="#modalFlipInY"  onclick="addrow();">ADD</button> 
                              </div>--%>
                              <div class="form-group">
                              <button type="button" class="btn btn-primary" style="float:right;margin-top: 6px;margin-right: 10px;width: 100px;" data-toggle="modal" data-target="#modalFlipInY">Show</button>
                              </div> 
                        </div>
                        <div class="card-body">
                            <asp:HiddenField runat="server" ID="hdnBookID" />
                            <asp:Label runat="server" ID="Label1"></asp:Label>
                           <table id="demo-datatables-fixedheader-2" class="table table-hover table-striped table-nowrap dataTable" cellspacing="0" width="100%" data-page-length="100">
                        <thead>
                            <tr>
                                <th>Sr. No.</th>
                                <th>Name</th>
                                <th>Actions</th>
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
        <div class="modal-dialog modal-lg"> 
            <div class="modal-content animated flipInY">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" onclick="">
                        <span aria-hidden="true">×</span>
                        <span class="sr-only">Close</span>

                    </button>
                </div>
                <div class="modal-body">
                          <div class="card-header">
                            <h3 style="float:left">Members Information</h3>
                              <div class="form-group">
                          <%--   <label class="txtwhite" hidden id="hdnlbl">BookEdition:</label>--%>
                            <button type="button" class="btn btn-primary" style="float: right;margin-top: 3px;margin-right: 1px;margin-left: 75px;width: px;" data-target="#modalFlipInY" onclick="addrow();">ADD</button>
                              </div>
                              <div class="form-group">
                           <button type="button" class="btn btn-primary" style="float: right;margin-top: -12px;margin-bottom: px;margin-right: 1px;margin-left: 5px;width: px;" onclick="SaveData();">Save</button>
                              </div> 
                             <%-- <div class="form-group">
                            <button type="button" class="btn btn-primary" style="float:right;margin-top: -13px;margin-right: 1px;width: px;background-color:red;" onclick="DeleteAll();">Delete</button>
                              </div>--%>
                        </div>
                        <div class="card-body">
                            <asp:HiddenField runat="server" ID="HiddenField1" />
                            <asp:Label runat="server" ID="Label2"></asp:Label>
                           <table id="demo-datatables-fixedheader-1" class="table table-hover table-striped table-nowrap dataTable" cellspacing="0" width="100%" data-page-length="100">
                        <thead>
                            <tr>
                                <th>Sr. No.</th>
                                <th>Book</th>
                                <th>Debit</th>
                                <th>Credit</th> 
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>   
                        </tbody>
                    </table>
                        </div>
                    </div>
               
                <div class="modal-footer">
                    <div class="m-t-lg">
                        <button class="btn btn-success" type="button" onclick="SaveData();">Save</button>
                        <button class="btn btn-default" data-dismiss="modal" type="button" onclick="clearAll();">Cancel</button>
                    </div>
                </div>
                 </div>  
        </div>
        </div>
        
</asp:Content>
