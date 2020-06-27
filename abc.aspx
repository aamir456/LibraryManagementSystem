<%@ Page Title="" Language="C#" MasterPageFile="~/MainSite.Master" AutoEventWireup="true" CodeBehind="abc.aspx.cs" Inherits="LibraryManagementSystem.abc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        let lineNo = 1;
        $(document).ready(function () {
            $(".Add-Row").click(function () {
                markup = "<tr><td>This is row "
                    + lineNo + "</td></tr>";
                tableBody = $("#demo-datatables-fixedheader-1");
                tableBody.append(markup);
                lineNo++;
            }); 
        });
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
                            <button type="button" class="btn btn-primary" onclick="hide();"style="float:right;margin-top: 9px;"  data-toggle="modal" data-target="#modalFlipInY">Add New</button> 
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
                <button type="button" class="btn btn-primary" style="float:left;margin-top: 10px;"  data-toggle="modal" data-target="#demo-datatables-fixedheader-1" onclick=".click()">Add Row</button> 
                <div class="modal-body">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12">
                             <asp:HiddenField runat="server" ID="hdnMemberInformationID" />
                            <label class="txtwhite"> MemberTypeID:</label>
                            <input id="TxtMemberTypeID" type="text" placeholder="Member Type" class="form-control cleartext" />
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
                            <input id="TxtGender" type="text" placeholder="Gender" class="form-control cleartext" />
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
                        <button class="btn btn-default" data-dismiss="modal" type="button" onclick="clearAll();">Cancel</button>
                    </div>
                </div>
                 </div>
            </div>
        </div>
</asp:Content>
