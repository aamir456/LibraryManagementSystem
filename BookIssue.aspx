<%@ Page Title="" Language="C#" MasterPageFile="~/MainSite.Master" AutoEventWireup="true" CodeBehind="BookIssue.aspx.cs" Inherits="LibraryManagementSystem.BookIssue" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function () {
            loadata(0);
            $("#Issue").addClass('active');
            LoadDropDownMember(0);
            LoadDropdownBook(0);
            Add7Days();
        });
        function DateFromString(str, days) {
            str = str.split(/\D+/);
            str = new Date(str[2], str[0] - 1, (parseInt(str[1]) + parseInt(days)));
            return MMDDYYYY(str);
        }
        function MMDDYYYY(str) {
            var ndateArr = str.toString().split(' ');
            var Months = 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec';
            return (parseInt(Months.indexOf(ndateArr[1]) / 4) + 1) + '/' + ndateArr[2] + '/' + ndateArr[3];
        }
        function Add7Days(val2,date) {
           // var date = '03/30/2020';
            var ndate = DateFromString(date, val2);
            $("#ContentPlaceHolder1_TxtReturnDate").val(ndate);
        }
      
        function MemberDayLimit(MemberID) {
            var valueobject = {};
            valueobject['OpCode'] = 12;
            valueobject['MemberID'] = MemberID;
            GetDataGrid("1", FillDays, valueobject, "SPR_BookIssue");
           
        }
        function FillDays(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var table = xml.find("Table");
            table.each(function () {
                var TableRow = $(this);
                Add7Days(TableRow.find("DayLimit").text(), TableRow.find("issueDate").text());  
            });
        }
        function clearall() {
            $('.clear').val("");
            $(".drop").prop('selectedIndex', 0);
        }
        function loadrepeators(response) {
            if (response.d == "") {
                SetModelDisplay("modalFlipInY", "hide");
                loadata(0);
                clearall();
                Add7Days();
                $('#ContentPlaceHolder1_hdnBookIssueID').val("");
            }
            else {
                alert(response.d);
            }
        }
        function insertdata() {
            if ( ValidateTextBox($("#ContentPlaceHolder1_TxtReturnDate"),'Book Return Date canot be null')) {
                var valueobject = {};
                if ($("#ContentPlaceHolder1_hdnBookIssueID").val() != "") {
                    valueobject['OpCode'] = 3;
                    valueobject['IssueID'] = $("#ContentPlaceHolder1_hdnBookIssueID").val().trim();
                }
                else {
                    valueobject['OpCode'] = 1;
                }
                valueobject['BookID'] = $("#<%=ddlBookID.ClientID%> option:selected").val();
                valueobject['MemberID'] = $("#<%=ddlMemberID.ClientID%> option:selected").val();
                MemberDayLimit($("#ContentPlaceHolder1_ddlMemberID").val());
                <%--valueobject['IssueDate'] = ([$("#<%=TxtIssueDate.ClientID%>").val().split("/")[1], $("#<%=TxtIssueDate.ClientID%>").val().split("/")[0], $("#<%=TxtIssueDate.ClientID%>").val().split("/")[2]]).join("/"); --%>
                valueobject['ReturnDate'] = $("#<%=TxtReturnDate.ClientID%>").val();
                valueobject['TotalFine'] = $("#TxtTotalFine").val().trim();
                GetDataGrid("-1", loadrepeators, valueobject, "SPR_BookIssue");
            }
        }
        function deletedata(IssueID) {
            var v = confirm('Sure');
            if (v === true) {
                var valueobject = {};
                valueobject['OpCode'] = 4;
                valueobject['IssueID'] = IssueID;
            }
            GetDataGrid("-1", loadrepeators, valueobject, "SPR_BookIssue");
        }
        function FillEditGrid(response) {
            SetModelDisplay("modalFlipInY", "show")
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var DataTable = xml.find("Table");
            DataTable.each(function () {
                var TableRow = $(this);
                $("#ContentPlaceHolder1_hdnBookIssueID").val(TableRow.find("IssueID").text());
                $("#ContentPlaceHolder1_ddlBookID").val(TableRow.find("BookID").text());
                $("#ContentPlaceHolder1_ddlMemberID").val(TableRow.find("MemberID").text());
                //$("#TxtIssueDate").val(TableRow.find("IssueDate").text());
                $("#TxtReturnDate").val(TableRow.find("ReturnDate").text());
                $("#TxtTotalFine").val(TableRow.find("TotalFine").text());
            })
        }
        function FillGrid(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var table = xml.find("Table");
            var tbl = $("#demo-datatables-fixedheader-1").DataTable();
            count = 0;
            tbl.clear();
            if (table.length > 0) {
                table.each(function () {
                    count += 1;
                    var TableRow = $(this);
                    tbl.row.add([
                        count,
                        TableRow.find("Name").text(),
                        TableRow.find("FullName").text(),
                        TableRow.find("IssueDate").text(),
                        TableRow.find("ReturnDate").text(),
                        TableRow.find("TotalFine").text()
                        , '<a href="#" id ="btnedit" onclick="loadata(' + TableRow.find("IssueID").text() + ')" + class="icon icon-pencil" style="color: black"</a>&ensp; | &ensp;' +
                        '<a href="#" id="btndelete" onclick="deletedata(' + TableRow.find("IssueID").text() + ')" + class="icon icon-trash" style="color:red"</a>' 
                                    
                    ]);
                    tbl.draw(false);
                });
            }
            else {
                tbl.draw(false);
            }
        }
        function loadata(record) {
            var valueobject = {};
            if (record > 0) {
                valueobject['OpCode'] = 2;
                valueobject['IssueID'] = record;
                GetDataGrid("1", FillEditGrid, valueobject, "SPR_BookIssue");
            }
            else {
                valueobject['OpCode'] = 2;
                GetDataGrid("1", FillGrid, valueobject, "SPR_BookIssue");
            }
        }
        
        function FillDropDownGridBook(response) {
            var xmlDoc = $.parseXML(response.d)
            var xml = $(xmlDoc);
            var Table = xml.find("Table");
            $("#ContentPlaceHolder1_ddlBookID").empty();
            Table.each(function () {
                var TableRow = $(this);
                $("#ContentPlaceHolder1_ddlBookID").append('<option value="' + TableRow.find("BookID").text() + '">' + TableRow.find("Name").text() + '</option>');
            })
        }
        function LoadDropdownBook() {
            var valueobject = {};
            valueobject['OpCode'] = 5;
            GetDataGrid("1", FillDropDownGridBook, valueobject, "SPR_BookIssue");
        }
        function FillDropDownGridMember(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var DataTable = xml.find("Table");
            $("#ContentPlaceHolder1_ddlMemberID").empty();
            DataTable.each(function () {
                var tablerow = $(this);
                $("#ContentPlaceHolder1_ddlMemberID").append('<option value="' + tablerow.find("MemeberID").text() + '">' + tablerow.find("FullName").text() + '</option>');
            })
            MemberDayLimit($("#ContentPlaceHolder1_ddlMemberID option:selected").val());

        }
        function LoadDropDownMember() {
            var valueobject = {};
            valueobject['OpCode'] = 6;
            GetDataGrid("1", FillDropDownGridMember, valueobject, "SPR_BookIssue");
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
                            <h3 style="float:left">Book Issue Record</h3>
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
                                <th>Book Name</th>
                                <th>Member Name</th>
                                <th>Issue Date</th>
                                <th>Return Date</th>
                                <th>Payable Amount</th>
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
                    <h3 class="txtwhite">ADD/Edit Book  issuance</h3>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12">
                             <asp:HiddenField runat="server" ID="hdnBookIssueID" />
                            <asp:HiddenField runat="server" ID="hdnBookID" />
                            <label class="txtwhite"> Select Book:</label>
                            <asp:DropDownList ID="ddlBookID" runat="server" CssClass="form-control drop"  DataTextField="BookQuantity" DataValueField="BookID"></asp:DropDownList>
                        </div> 
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <asp:HiddenField runat="server" ID="hdnMemberID" />
                            <label class="txtwhite"> Select Member:</label>
                            <asp:DropDownList ID="ddlMemberID" runat="server" CssClass="form-control drop" DataTextField="Member" onchange="MemberDayLimit(this.value)" DataValueField="MemberID" ></asp:DropDownList>
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">Return Date:</label>
                            <asp:TextBox runat="server" ID="TxtReturnDate" placeholder="Return Date" autocomplete="off" data-provide="datepicker" data-date-clear-btn="true" data-date-today-highlight="true" data-date-format="mm/dd/yyyy" data-date-autoclose="true" CssClass="form-control clear"></asp:TextBox>
                        </div>    
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">Enter Total Fine:</label>
                             <input id="TxtTotalFine" type="text" placeholder="Total Amount" class="form-control clear"  />
                        </div>    
                    </div>
                    </div>
                <div class="modal-footer">
                    <div class="m-t-lg">
                        <button class="btn btn-success" type="button" onclick="insertdata();">Save</button>
                        <button class="btn btn-default" data-dismiss="modal" type="button" onclick="clearall();">Cancel</button>
                    </div>
                </div>
                 </div>
            </div>
        </div>
  
</asp:Content>
