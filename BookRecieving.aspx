<%@ Page Title="" Language="C#" MasterPageFile="~/MainSite.Master" AutoEventWireup="true" CodeBehind="BookRecieving.aspx.cs" Inherits="LibraryManagementSystem.BookRecieving" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
 <script>
     $(document).ready(function () {
         LoadData(0);
         $("#Recieving").addClass('active');
         LoadDropdownMemberIssueID(0);
     
        // CalculateDiff();
     });
     function finecheck(val) {
         if ($("#TxtTotalAmount").val() >= parseInt(val)) {
             $("#TxtRemainingAmount").val(parseInt($("#TxtTotalAmount").val()) - parseInt(val));
         }
         else {
             $("#TxtPaidAmount").val("");
             $("#TxtRemainingAmount").val("");
         }
     }
     function CalculateDiff(sd,ed,fine) {
         var start = new Date(sd),
             end = new Date(ed),
             diff = new Date(end - start),
             days = diff / 1000 / 60 / 60 / 24;
         if (Math.round(days)>0) {
             $('#TxtDays') .val(Math.round(days) * parseInt(fine));
         }
         else {
             $('#TxtDays').val(0);
         }
         
         //days; //=> 8.525845775462964
       //  var IssueDate = '03/10/2020';
       //  var ReturnDate = '03/16/2020';
         //var start = '03/10/2020';
         //var end = '03/16/2020';
         // end - start returns difference in milliseconds 
         //var diff = new Date(end - start);
         // get days
         //var days = diff / 1000 / 60 / 60 / 24;
        
         //if (IssueDate != "" && ReturnDate != "") {
         //    var millisecondsPerDay = 1000 * 60 * 60 * 24;
         //    var diff_date = ReturnDate.getTime() - IssueDate.getTime();
         //    var result = (diff_date / millisecondsPerDay);
         //    //var days = Math.floor(((diff_date % 31536000000) % 2628000000) / 86400000);
         //    //$("#Result").html(years + " year(s) " + months + " month(s) " + days + " and day(s)");
         //    alert((Math.floor(result)) + "and day(s)");
         //}
         //else
         //{
         //    alert("Please select dates");
         //    return false;
         //}
     }
     //function CalculateDays(RecievingID) {
     //    var valueobject = {};
     //    valueobject['OpCode'] = 7;
     //    valueobject['ReceivingID'] = RecievingID;
     //    GetDataGrid("1", Issue$Return, valueobject, "SPR_BookReturn");
     //}
     //function Issue$Return(response) {
     //    var xmlDoc = $.parseXML(response.d);
     //    var xml = $(xmlDoc);
     //    var DataTable = xml.find("Table");
     //    DataTable.each(function () {
     //        var TableRow = $(this);
     //        CalculateDiff(TableRow.find("IssueDate").text(), TableRow.find("ReturnDate").text());
     //    })
     //}
     function clearall() {
         $('clear').val("");
         $("#ContentPlaceHolder1_hdnBookReceivedID").val("");
     }
     
     function InsertData() {
         if (ValidateTextBox($("#ContentPlaceHolder1_TxtReturnDate"), 'Return Date canot be null')) {
             var valueobject = {};
             if ($("#ContentPlaceHolder1_hdnBookReceivedID").val() != "") {
                 valueobject['OpCode'] = 3;
                 valueobject['ReceivingID'] = $("#ContentPlaceHolder1_hdnBookReceivedID").val();
             }
             else {
                 valueobject['OpCode'] = 1;
             }
             valueobject['MemberID'] = $("#<% = ddlIssuedMemberID.ClientID%> option:selected").val();
             valueobject['BookID'] = $("#<% = ddlBookID.ClientID%> option:selected").val();
             valueobject['ReturnDate'] = $("#<%=TxtReturnDate.ClientID%>").val();
             valueobject['TotalFine'] = $("#TxtDays").val();
             GetDataGrid("-1", loadrepeators, valueobject, "SPR_BookReturn");
         }
     }
     
     function LoadData(record) {
         var valueobject = {};
         if (record > 0) {
             valueobject['OpCode'] = 2;
             valueobject['ReceivingID'] = record;
             GetDataGrid("1", FillEditGrid, valueobject, "SPR_BookReturn");
         }
         else {
             valueobject['OpCode'] = 2;
             GetDataGrid("1", FillGrid, valueobject, "SPR_BookReturn");
         }
     }
     function FillEditGrid(response) {
         SetModelDisplay("modalFlipInY", "show")
         var xmlDoc = $.parseXML(response.d);
         var xml = $(xmlDoc);
         var DataTable = xml.find("Table");
         DataTable.each(function () {
             var TableRow = $(this);
             $("#ContentPlaceHolder1_hdnBookReceivedID").val(TableRow.find("ReceivingID").text());
             $("#ContentPlaceHolder1_ddlIssuedMemberID").val(TableRow.find("MemberID").text());
             $("#ContentPlaceHolder1_ddlBookID").val(TableRow.find("BookID").text());
             $("#ContentPlaceHolder1_TxtReturnDate").val(TableRow.find("ReturnDate").text());
             $("#TxtDays").val(TableRow.find("TotalFine").text());
         })
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
                 var TableRow = $(this);
                 count += 1;
                 var fine = "";
                 if (TableRow.find("TotalFine").text()==0) {
                     fine = "";
                 }
                 else {
                     fine = '<a href="#" id ="btnpay" onclick="BookFine(' + TableRow.find("ReceivingID").text() + ',' + TableRow.find("TotalFine").text() + ')" + class="icon icon-plus" style="color: green" </a> &ensp; | &ensp;' +
                         '<a href="#" id="btnpayment" onclick="loadfine(' + TableRow.find("ReceivingID").text() + ')" + class="icon icon-eye" style="color:blue"</a>&ensp; | &ensp;';
                 }
                 tbl.row.add([
                     count,
                     TableRow.find("FullName").text(),
                     TableRow.find("Name").text(),
                     TableRow.find("ReturnDate").text(),
                     TableRow.find("TotalFine").text()
                     ,/* '<a href="#" id="btnedit" onclick="LoadData(' + TableRow.find("ReceivingID").text() + ')" + class="icon icon-pencil" style="color:black"</a>&ensp; | &ensp;' +*/
                     fine +
                     '<a href="#" id ="btndelete" onclick="deletedata(' + TableRow.find("ReceivingID").text() + ')" + class="icon icon-trash" style="color:red"</a>'

                 ]);
                 tbl.draw(false);
             });
         }
         else {
             tbl.draw(false);
         }
     }
     function deletedata(ReceivingID) {
         var v = confirm('Sure');
         if (v === true) {
             var valueobject = {};
             valueobject['OpCode'] = 4;
             valueobject['ReceivingID'] = ReceivingID;
         }
         GetDataGrid("-1", loadrepeators, valueobject, "SPR_BookReturn");
     }
  
     function LoadDropdownMemberIssueID() {
         var valueobject = {};
         valueobject['OpCode'] = 5;
         GetDataGrid("1", FillGridMemberIssueID, valueobject, "SPR_BookReturn");
     }
     function FillGridMemberIssueID(response) {
         var xmlDoc = $.parseXML(response.d);
         var xml = $(xmlDoc);
         var table = xml.find("Table");
         $("#ContentPlaceHolder1_ddlIssuedMemberID").empty();
         table.each(function () {
             var tablerow = $(this);
             $("#ContentPlaceHolder1_ddlIssuedMemberID").append('<option value="' + tablerow.find("MemeberID").text() + '">' + tablerow.find("FullName").text() + '</option>');
         })
         LoadDropDownBook($("#<% = ddlIssuedMemberID.ClientID%> option:selected").val());
     }
     function LoadDropDownBook(val) {
         var valueobject = {};
         valueobject['OpCode'] = 6;
         valueobject['MemberID'] = val;
         GetDataGrid("1", FillGridBooks, valueobject, "SPR_BookReturn");
     }
     function FillGridBooks(response) {
         $("#ContentPlaceHolder1_ddlBookID").empty();
         var xmlDoc = $.parseXML(response.d);
         var xml = $(xmlDoc);
         var Table = xml.find("Table");
         Table.each(function () {
             var tablerow = $(this);
             $("#ContentPlaceHolder1_ddlBookID").append('<option value="' + tablerow.find("BookID").text() + '">' + tablerow.find("Name").text() + '</option>');
         })
     }
     function loadrepeators(response) {
         if (response.d == "") {
             SetModelDisplay("modalFlipInY", "hide");
             LoadData(0);
             clearall();
         }
         else {
             alert(response.d);
         }
     }
     function differncedate(vals) {
         if (vals!="") {
             $("#ContentPlaceHolder1_hdnBookReceiveddate").val(vals);
             var valueobject = {};
             valueobject['OpCode'] = 7;
             valueobject['MemberID'] = $("#<% = ddlIssuedMemberID.ClientID%> option:selected").val();
             valueobject['BookID'] = $("#<% = ddlBookID.ClientID%> option:selected").val();
             GetDataGrid("1", FillGridMemberdate, valueobject, "SPR_BookReturn");
         }
        
         
     }
     function FillGridMemberdate(response) {
         var xmlDoc = $.parseXML(response.d);
         var xml = $(xmlDoc);
         var Table = xml.find("Table");
         Table.each(function () {
             var tablerow = $(this);
             CalculateDiff(tablerow.find("ReturnDate").text(), $("#ContentPlaceHolder1_hdnBookReceiveddate").val(),tablerow.find("TotalFine").text());
         })
     }
     function BookFine(BookIssueID, TotalAmount) {
         SetModelDisplay("modalFlipInY1", "show")
         $("#ContentPlaceHolder1_hdnIssueID").val(BookIssueID);
         $("#TxtTotalAmount").val(TotalAmount);
     }
     function FillFineEditGrid(response) {
         SetModelDisplay("modalFlipInY1","show")
         var xmlDoc = $.parseXML(response.d);
         var xml = $(xmlDoc);
         var DataTable = xml.find("Table");
         DataTable.each(function () {
             var Tablerow = $(this);
             $("#ContentPlaceHolder1_hdnPayID").val(Tablerow.find("PayID").text());
             $("#TxtTotalAmount").val(Tablerow.find("TotalAmount").text());
             $("#TxtPaidAmount").val(Tablerow.find("PaidAmount").text());
             $("#TxtRemainingAmount").val(Tablerow.find("RemainingAmount").text());
         })
     }
     function FillFineGrid(response) {

         SetModelDisplay("modalFlipInY2", "show")
         var xmlDoc = $.parseXML(response.d);
         var xml = $(xmlDoc);
         var table = xml.find("Table");
         var table1 = xml.find("Table1");
         var tbl = $("#demo-datatables-fixedheader-2").DataTable();
         var count = 0;
         tbl.clear();
         if (table.length>0) {
             table.each(function () {
                 count += 1;
                 var tablerow = $(this);
                 tbl.row.add([
                     count,
                     tablerow.find("TotalAmount").text(),
                     tablerow.find("PaidAmount").text(),
                     tablerow.find("RemainingAmount").text()
                     , '<a href="#" id="btnedit" onclick="loadfinedata(' + tablerow.find("PayID").text() + ')" + class="icon icon-pencil" style="color:black"</a>&ensp;|&ensp;' +
                     '<a href="#" id="btndelete" onclick="deletefine(' + tablerow.find("PayID").text() + ')" + class="icon icon-trash" style="color:red"</a>'
                 ]);
                 tbl.draw(false);
             });
         }
         else {
             tbl.draw(false);
         }
         $("#btnAdddiv").empty();
         var leng = table1.length;
         count = 0;
         table1.each(function () {
             var TableRow = $(this);
             count = count + 1;
             if (count == leng) {
                 $("#btnAdddiv").append('<button type="button" id="btnAddFine" onclick="BookFine(' + TableRow.find("ReceivingID").text() + ',' + TableRow.find("RemainingAmount").text() + ')" class="btn btn-primary">Add New</button>');
             }
         });
     }
     function loadfine(record) {
         $('#ContentPlaceHolder1_hdnIssueID').val(record);
             var valueobject = {};
             valueobject['OpCode'] = 8;
             valueobject['IssueID'] = record;
             GetDataGrid("1", FillFineGrid, valueobject, "SPR_BookIssue");
     }
     function loadfinedata(record) {
         if (record > 0) {
             var valueobject = {};
             valueobject['OpCode'] = 9;
             valueobject['PayID'] = record;
             GetDataGrid("1", FillFineEditGrid, valueobject, "SPR_BookIssue");
         }
     }
    
     function insertpayment() {
         if (ValidateTextBox($("#TxtTotalAmount"), 'Total Amount canot be null') && ValidateTextBox($("#TxtPaidAmount"), 'Paid Amount canot be null')) {
             var valueobject = {};
             if ($("#ContentPlaceHolder1_hdnPayID").val() != "") {
                 valueobject['OpCode'] = 10;
                 valueobject['PayID'] = $("#ContentPlaceHolder1_hdnPayID").val().trim();
             }
             else {
                 valueobject['OpCode'] = 7;
             }
             valueobject['IssueID'] = $("#ContentPlaceHolder1_hdnIssueID").val();
             valueobject['TotalAmount'] = $("#TxtTotalAmount").val().trim();
             valueobject['PaidAmount'] = $("#TxtPaidAmount").val().trim();
             valueobject['RemainingAmount'] = $("#TxtRemainingAmount").val().trim();
             GetDataGrid("-1", loadrepeator, valueobject, "SPR_BookIssue");
         }
     }
     function deletefine(PayID) {
         var v = confirm('Sure');
         if (v === true) {
             var valueobject = {};
             valueobject['OpCode'] = 11;
             valueobject['PayID'] = PayID;
         }
         GetDataGrid("-1", loadrepeator, valueobject, "SPR_BookIssue");
     }
     function loadrepeator(response) {
         if (response.d == "") {
             loadfine($('#ContentPlaceHolder1_hdnIssueID').val());
            // LoadData(0);
             //loadfinedata($('#ContentPlaceHolder1_hdnPayID').val());
             $("#TxtTotalAmount").val("");
             $("#TxtPaidAmount").val("");
             $("#TxtRemainingAmount").val("");
             clearall();
             $("#ContentPlaceHolder1_hdnPayID").val("");
             SetModelDisplay("modalFlipInY1", "hide");
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
                            <h3 style="float:left">Receiving Record</h3>
                              <div class="form-group">
                            <button type="button" class="btn btn-primary"  style="float:right;margin-top: 9px;"  data-toggle="modal" data-target="#modalFlipInY">Add New</button>
                              </div>
                        </div>
                        <div class="card-body">
                            <asp:Label runat="server" ID="Label1"></asp:Label>
                           <table id="demo-datatables-fixedheader-1" class="table table-hover table-striped table-nowrap dataTable" cellspacing="0" width="100%" data-page-length="100">
                        <thead>
                            <tr>
                                <th>Sr. No.</th>
                                <th>Member Name</th>
                                <th>Book Name</th>
                                <th>Return Date</th>
                                <th>TotalFine</th>
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
                    <h3 class="txtwhite">ADD/Edit Book Received</h3>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12">
                             <asp:HiddenField runat="server" ID="hdnBookReceivedID" />
                             <asp:HiddenField runat="server" ID="hdnBookReceiveddate" />
                            <label class="txtwhite">Member:</label>
                            <asp:DropDownList ID="ddlIssuedMemberID" runat="server" CssClass="form-control drop" DataTextField="Member" DataValueField="MemberID" onchange="LoadDropDownBook(this.value)"></asp:DropDownList>
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">Book:</label>
                            <asp:DropDownList ID="ddlBookID" runat="server" CssClass="form-control drop"  DataTextField="BookQuantity" DataValueField="BookID"></asp:DropDownList>
                        </div> 
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">Return Date:</label>
                            <asp:TextBox runat="server" ID="TxtReturnDate" onchange="differncedate(this.value)" placeholder="Select Return Date" autocomplete="off" data-provide="datepicker" data-date-clear-btn="true" data-date-today-highlight="true" data-date-format="mm/dd/yyyy" data-date-autoclose="true" CssClass="form-control clear"></asp:TextBox>
                        </div>   
                         <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">Fine:</label>
                            <input id="TxtDays" type="text" placeholder="" class="form-control clearall" />
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
      <div id="modalFlipInY2" tabindex="-1" role="dialog" class="modal in">
         <div class="modal-dialog modal-lg"> 
            <div class="modal-content animated flipInY">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" onclick="">
                        <span aria-hidden="true">×</span>
                        <span class="sr-only">Close</span>
                    </button>
                    <h3 class="txtwhite">Fine Record</h3>
                </div>
                <div class="modal-body">
                    <div class="row">
                      <div  id="btnAdddiv"></div>
                        <asp:Label runat="server" ID="Label2"></asp:Label>
                           <table id="demo-datatables-fixedheader-2" class="table table-hover table-striped table-nowrap dataTable" cellspacing="0" width="100%" data-page-length="100">
                        <thead>
                            <tr>
                                <th>Sr. No.</th>
                                <th>Total Amount</th>
                                <th>Paid Amount</th>
                                <th>Remaining Amount</th>
                                <th>Action/s</th> 
                            </tr>
                        </thead>
                        <tbody>   
                        </tbody>
                    </table>
                    </div>
                    </div>
                <div class="modal-footer">
                    <button class="btn btn-default" data-dismiss="modal" type="button" onclick="clearall();">Done</button>
                </div>
                 </div>
            </div>
        </div>
    <div id="modalFlipInY1" tabindex="-1" role="dialog" class="modal in">
        <div class="modal-dialog"> 
            <div class="modal-content animated flipInY">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" onclick="">
                        <span aria-hidden="true">×</span>
                        <span class="sr-only">Close</span>
                    </button>
                    <h3 class="txtwhite">Book Fine</h3>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12">
                             <asp:HiddenField runat="server" ID="hdnPayID" />
                            <asp:HiddenField runat="server" ID="hdnIssueID" />
                            <label class="txtwhite">Total Amount:</label>
                            <input id="TxtTotalAmount" type="text" placeholder="Total Amount" class="form-control" />
                        </div>                        
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">Paid Amount:</label>
                            <input id="TxtPaidAmount" type="text" placeholder="Paid Amount" onkeyup="finecheck(this.value)" class="form-control clear" />
                        </div>
                         <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">Remaining amount :</label>
                            <input id="TxtRemainingAmount" type="text" placeholder="Remaining Amount" class="form-control clear" />
                        </div>
                    </div>
                    </div>
                <div class="modal-footer">
                    <div class="m-t-lg">
                        <button class="btn btn-success" type="button" onclick="insertpayment();">Save</button>
                        <button class="btn btn-default" data-dismiss="modal" type="button" onclick="clearall();">Cancel</button>
                    </div>
                </div>
                 </div>
            </div>
        </div>
</asp:Content>
