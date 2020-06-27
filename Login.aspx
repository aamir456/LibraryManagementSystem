 <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="LibraryManagementSystem.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   
   <meta charset="UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
     <title>Library
</title>
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no"/>
     <link rel="apple-touch-icon" sizes="180x180" href="apple-touch-icon.png"/>
   
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
<link rel="icon" href="favicon.ico" type="image/x-icon" />

     
    <link rel="mask-icon" href="safari-pinned-tab.svg" color="#00aced"/>
    <meta name="theme-color" content="#ffffff"/>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,400italic,500,700"/>
    <link rel="stylesheet" href="css/vendor.min.css"/>
    <link rel="stylesheet" href="css/elephant.min.css"/>
    <link rel="stylesheet" href="css/login-2.min.css"/>
    <script type="text/javascript">
         function CheckfromAuth() {
             var TxtUserName = document.getElementById('TxtUserName');
             var txtpassword = document.getElementById('txtpassword');
             if (TxtUserName.value.length == 0) {
                 alert('User Name cannot be blank.');
                 TxtUserName.focus();
                 return false;
             }
             else if (txtpassword.value.length == 0) {
                 alert('Password cannot be blank.');
                 txtpassword.focus();
                 return false;
             }
             return true;
         }

    </script>
<style>
    body {
      background: url(img/books-1281581_1920.jpg) no-repeat center center fixed;
        -webkit-background-size: cover;
        -moz-background-size: cover;
        -o-background-size: cover;
        background-size: cover;
    }
lable { color:#fff;}
.login-body {
	background: #00000063;
    background-image: initial;
    background-position-x: initial;
    background-position-y: initial;
    background-size: initial;
    background-repeat-x: initial;
    background-repeat-y: initial;
    background-attachment: initial;
    background-origin: initial;
    background-clip: initial;
    background-color: rgba(0, 0, 0, 0.39);
}
 
</style>
 
</head>
<body>
      <form id="form1" runat="server">

         <div class="login">
      <div class="login-body">
          
       
        <div class="login-form">
          <div data-toggle="validator">
            <div class="form-group">
              <label for="email" style="color: #fff;">User Name</label>
                <asp:TextBox ID="TxtUserName" class="form-control" runat="server" autocomplete="off"  aria-describedby="emailHelp" placeholder="Enter User Name" required="true"></asp:TextBox>
            </div>
            <div class="form-group">
              <label for="password" style="color: #fff;">Password</label>
                <asp:TextBox class="form-control" id="txtpassword" runat="server" TextMode="Password" autocomplete="off" placeholder="Enter Password" required="true"></asp:TextBox>
            </div>
              <div class="form-group">
                  <asp:CheckBox runat="server" ID="check" Text="only Member " style="color:whitesmoke" />
              </div>
            <asp:Button ID="btnLogin" CssClass="btn btn-primary btn-block" runat="server" Text="Login" OnClick="btnLogin_Click" OnClientClick="return CheckfromAuth();" />
          </div>
            <div id="DivError" class="geterror" runat="server">
                                                    <asp:Label ID="lblError" runat="server"></asp:Label>
                                                </div>
        </div>
      </div>
      
    </div>
    </form>
     <script src="js/vendor.min.js"></script>
    <script src="js/elephant.min.js"></script>
</body>
</html>
