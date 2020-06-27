<%@ Page Title="" Language="C#" MasterPageFile="~/MainSite.Master" AutoEventWireup="true" CodeBehind="MemberInformation.aspx.cs" Inherits="LibraryManagementSystem.MemberInfo" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function () {
            loadata(0);
            LoadDropDownMemberType();
            Loadrepeator();
            $("#Members").addClass('active');
        });
        function clearall() {
            $ ('cleartext').val("");
            $("#ContentPlaceHolder1_hdnMemberInformationID").val("");
        }
        function deletedata(MemberID) {
            var a = confirm('Sure');
            if (a === true) {
                var valueobject = {};
                valueobject['OpCode'] = 3;
                valueobject['MemeberID'] = MemberID;
                GetDataGrid("-1", Loadrepeator, valueobject,"SPR_Member");
            }
        }
        function loadata(record) {
            var valueobject = {};
            if (record > 0) {
                valueobject['OpCode'] = 1;
                valueobject['MemeberID'] = record;
                GetDataGrid("1", filleditgrid, valueobject, "SPR_Member");
            }
            else {
                valueobject['OpCode'] = 1;
                GetDataGrid("1", fillgrid, valueobject, "SPR_Member");
            }
        }
        function filleditgrid(response) {
            SetModelDisplay("modalFlipInY", 'show');
            var xmldoc = $.parseXML(response.d);
            var xml = $(xmldoc);
            var TableData = xml.find("Table");
            TableData.each(function() {
                var Tablerow = $(this);
                $("#ContentPlaceHolder1_hdnMemberInformationID").val(Tablerow.find("MemeberID").text());
                $("#ContentPlaceHolder1_ddlMemberType").val(Tablerow.find("MemberTypeID").text());
                $("#TxtFullName").val(Tablerow.find("FullName").text());
                $("#TxtFatherName").val(Tablerow.find("FatherName").text());
                if (Tablerow.find("Gender").text()=='male')
                {
                    $("#male").prop("checked", true);
                }
                else if (Tablerow.find("Gender").text() == 'female')
                {
                    $("#female").prop("checked",true);
                }
                else
                {
                    $("#other").prop("checked",true);
                }
                $("#TxtEmail").val(Tablerow.find('Email').text());
                $("#TxtPhoneNumber").val(Tablerow.find('PhoneNumber').text());
                $("#TxtAddress").val(Tablerow.find('Address').text());
                $("#TxtPassword").val(Tablerow.find('Password').text());
            })
        }
        function fillgrid(response) {
            var xmldoc = $.parseXML(response.d);
            var xml = $(xmldoc);
            var table = xml.find("Table");
            var tbl = $("#demo-datatables-fixedheader-1").DataTable();
            tbl.clear();
            var count = 0;
            if (table.length > 0) {
                table.each(function () {
                    var tablerow = $(this);
                    count += 1;
                    tbl.row.add([
                        count,
                        tablerow.find("FullName").text(),
                        tablerow.find("FatherName").text(),
                        tablerow.find("Email").text(),
                        tablerow.find("PhoneNumber").text(),
                        tablerow.find("Address").text(),
                        tablerow.find("MemeberType").text(),
                        tablerow.find("BookLimit").text(),
                        tablerow.find("DayLimit").text()
                        , '<a href="#" id="btnEdit" onclick="loadata(' + tablerow.find("MemeberID").text() + ')" + class="icon icon-pencil" style="color:black"></a>&ensp;| &ensp;' +
                        '<a href="#" id="btnDelete" onclick="deletedata(' + tablerow.find("MemeberID").text()+ ')" + class="icon icon-trash" style="color:red"></a>'
                    ]);
                    tbl.draw(false);
                });
            }
            else {
                tbl.draw(false);
            }
        }
        function insertdata() {
            if (ValidateTextBox($("#TxtFullName"), 'Full Name canot be null') && ValidateTextBox($("#TxtFatherName"), 'Father Name canot be Null') && ValidateTextBox($("#TxtEmail"), 'Email Address canot be Null') && ValidateTextBox($("#TxtPhoneNumber"), 'Phone Number canot be Null') && ValidateTextBox($("#TxtAddress"), 'Address canot be Null')) {
                var valueobject = {};
                if ($("#ContentPlaceHolder1_hdnMemberInformationID").val() != "") {
                    valueobject['OpCode'] = 4;
                    valueobject['MemeberID'] = $("#ContentPlaceHolder1_hdnMemberInformationID").val();
                }
                else {
                    valueobject['OpCode'] = 2;
                   
                }
                valueobject['MemberTypeID'] = $("#<%=ddlMemberType.ClientID%> option:selected").val();
                valueobject['FullName'] = $("#TxtFullName").val().trim();
                valueobject['FatherName'] = $("#TxtFatherName").val().trim();
                if ($("#male").prop("checked")) {
                    valueobject['Gender'] = $("#male").val().trim();
                }
                else if ($("#female").prop("checked")) {
                    valueobject['Gender'] = $("#female").val().trim();
                }
                else {
                    valueobject['Gender'] = $("#other").val().trim();
                }
                valueobject['Email'] = $("#TxtEmail").val().trim();
                valueobject['PhoneNumber'] = $("#TxtPhoneNumber").val().trim();
                valueobject['Address'] = $("#TxtAddress").val().trim();
                valueobject['Password'] = $("#TxtPassword").val().trim();
                GetDataGrid("-1", Loadrepeator, valueobject, "SPR_Member");
            }
        }
        function LoadDropDownMemberType() {
            var valueobject = {};
            valueobject['OpCode'] = 5;
            GetDataGrid("1", FillDropDownGridMemberType, valueobject, "SPR_Member");
        }
        function FillDropDownGridMemberType(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var DataTable = xml.find("Table");
            $("#ContentPlaceHolder1_ddlMemberType").empty();
            DataTable.each(function () {
                var tablerow = $(this);
                $("#ContentPlaceHolder1_ddlMemberType").append('<option value="' + tablerow.find("MemberTypeID").text() + '">' + tablerow.find("MemeberType").text() + '</option>');
            })
        }
       
        function Loadrepeator(response) {
            if (response.d == "") {
                SetModelDisplay("modalFlipInY", "hide");
                loadata(0);
                clearall();
                $('#ContentPlaceHolder1_hdnMemberInformationID').val("");
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
                                <th>Father Name</th>
                               <%-- <th>Gender</th>--%>
                                <th>Email Address</th>
                                <th>Phone Number</th>
                                <th>Address</th>
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
                            <asp:HiddenField runat="server" ID="hdnMemberInformationID" /> 
                            <label class="txtwhite">Member Type:</label>
                            <asp:DropDownList ID="ddlMemberType" runat="server" CssClass="form-control drop"  DataTextField="MemberType" DataValueField="MemberTypeID"></asp:DropDownList>
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">FullName:</label>
                            <input id="TxtFullName" type="text" placeholder="Full Name" class="form-control cleartext" />
                        </div>                        
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">FatherName:</label>
                            <input id="TxtFatherName" type="text" placeholder="Father Name" class="form-control cleartext" />
                        </div>
                         <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">Gender:</label>
                            <input type="radio" id="male" name="Gender" value="male" checked>
                            <label for="male">Male</label>
                            <input type="radio" id="female" name="Gender" value="female">
                            <label for="female">Female</label>
                            <input type="radio" id="other" name="Gender" value="other">
                            <label for="other">Other</label>
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">Email:</label>
                            <input id="TxtEmail" type="text" placeholder="Email" class="form-control cleartext" />
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">PhoneNumber:</label>
                            <input id="TxtPhoneNumber" type="text" placeholder="Phone Number" class="form-control cleartext" />
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">Address:</label>
                            <input id="TxtAddress" type="text" placeholder="Address" class="form-control cleartext" />
                        </div>
                        <div  class="col-lg-12 col-md-12 col-sm-12">
                            <label class="txtwhite">Password:</label>
                            <input id="TxtPassword" type="text" placeholder="Password" class="form-control cleartext" />
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
