using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLLV2;
using System.Data;
using System.Data.SqlClient;

namespace LibraryManagementSystem
{
    public partial class Login : System.Web.UI.Page
    {
        private string g_strErrorMessage = "";
        private string g_strErrorType = "";
        protected void Page_Load(object sender, EventArgs e)
        {
             DivError.Attributes["class"] = "alert alert-danger alert-dismissible";
            Session.Clear();
              DivError.Visible = false;
            lblError.Text = "";
            if (!Page.IsPostBack)
            {

            }
        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {

            bool status = false;
            bool Mstatus = false;
           
            #region Login
            try
            {
                /***************************************************************/
                // Validate User Against Data Base
                /***************************************************************/
                if (check.Checked == true)
                {
                    if ((TxtUserName.Text.Trim().Length != 0) && (txtpassword.Text.Trim().Length != 0))
                    {
                        string ErrorMessage = "";
                        DataTable DtUsers = Usersinfo.VerifyUser("2", TxtUserName.Text.Trim(), txtpassword.Text.Trim(), ref ErrorMessage);
                        if (ErrorMessage.Length < 1)
                        {
                            if (DtUsers.Rows.Count > 0)
                            {
                                Session["UserID"] = Convert.ToString(DtUsers.Rows[0]["MemeberID"]);
                                Session["Username"] = Convert.ToString(DtUsers.Rows[0]["FullName"]);
                                Session["RoleID"] =-1;
                                Mstatus = true;
                            }
                            else
                            {
                                DivError.Visible = true;
                                lblError.Text = "Invalid User Name or Password";
                            }
                        }
                        else
                        {
                            DivError.Visible = true;
                            lblError.Text = ErrorMessage;
                        }
                    }
                }
                else
                {
                    if ((TxtUserName.Text.Trim().Length != 0) && (txtpassword.Text.Trim().Length != 0))
                    {
                        string ErrorMessage = "";
                        DataTable DtUsers = Usersinfo.VerifyUser("1", TxtUserName.Text.Trim(), txtpassword.Text.Trim(), ref ErrorMessage);
                        if (ErrorMessage.Length < 1)
                        {
                            if (DtUsers.Rows.Count > 0)
                            {
                                Session["UserID"] = Convert.ToString(DtUsers.Rows[0]["UserID"]);
                                Session["Username"] = Convert.ToString(DtUsers.Rows[0]["Username"]);
                                Session["RoleID"] = Convert.ToString(DtUsers.Rows[0]["RoleID"]);
                                status = true;
                            }
                            else
                            {
                                DivError.Visible = true;
                                lblError.Text = "Invalid User Name or Password";
                            }
                        }
                        else
                        {
                            DivError.Visible = true;
                            lblError.Text = ErrorMessage;
                        }
                    }
                }
               
            }
            catch (Exception exp)
            {
                DivError.Visible = true;
                lblError.Text = exp.Message;
            }
            if (status)
            {
                Response.Redirect("Default.aspx");
            }
            if (Mstatus)
            {
                Response.Redirect("User.aspx");
            }

            #endregion
        }
    }
}