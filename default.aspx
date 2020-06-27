<%@ Page Title="" Language="C#" MasterPageFile="~/MainSite.Master" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="LibraryManagementSystem._default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function () {
            $("#Dashboards").addClass('active');
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%-- <div class="layout-content">
        <div class="layout-content-body">
          <div class="title-bar">
            
            <h1 class="title-bar-title"> 
              <span class="d-ib">Dashboard</span>
               <table id="BookTable2" class="table">
                        <thead>
                            <tr>
                               <th class="optioncol">Sr. No.</th> 
                                <th>BookID</th>
                                <th>Name</th>
                                <th>Writer</th>
                                <th>Code</th>
                                <th>Edition</th> 
                            </tr>
                        </thead>
                        <tbody>
                                      
                        </tbody>
                    </table>

              <span class="d-ib">
                <a class="title-bar-shortcut" href="#" title="Add to shortcut list" data-container="body" data-toggle-text="Remove from shortcut list" data-trigger="hover" data-placement="right" data-toggle="tooltip">
                  <span class="sr-only">Add to shortcut list</span>
                </a>
              </span>
            <%--</h1> 
          </div>
        






        </div>
      </div>--%>
</asp:Content>
