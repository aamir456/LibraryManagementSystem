using BLLV2;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace LibraryManagementSystem
{
    public class myclass
    {
        public static void AddParams(int _index, string _name, string _value, ref SqlParameter[] paramstostore)
        {
            paramstostore[_index] = new SqlParameter("@" + _name, SqlDbType.VarChar);
            paramstostore[_index].Value = _value;

        }
        public static void AddNewRowSingleColumn(int OpCode, string SpName, ref GridView dg, ref bool k_blnIsAddingNew, ref HtmlGenericControl DivError, ref Label _LblError)
        {
            string g_strErrorMessage = "";
            try
            {
                DataTable GridTable = GeneralBL.FillDataGrid(OpCode, SpName, ref g_strErrorMessage, "");
                //if ((GridTable.Rows.Count == 0) || (GridTable == null))
                //{
                //    DataRow dr = GridTable.NewRow();
                //    GridTable.Rows.Add(dr);
                //    dg.DataSource = GridTable;
                //    dg.DataBind();
                //}

                DataRow NewRow = GridTable.NewRow();
                Label lblName = new Label();
                if (dg.Rows.Count == 0)
                {
                    lblName.Text = "";
                }
                /************************************************************
                 * Here We have Two Options If the User is on First Pasge then
                 */
                //Label lblName = (Label)dg.Rows[0].FindControl(ControlName);

                int nNewItemIndex = dg.Rows.Count;

                if (nNewItemIndex < dg.PageSize)
                {
                    if (lblName.Text == "")
                    {
                        dg.EditIndex = nNewItemIndex;
                    }
                    else
                    {
                        dg.EditIndex = nNewItemIndex;
                    }
                }
                else
                {
                    int r = GridTable.Rows.Count;
                    int m_pageNumber = r / nNewItemIndex;
                    dg.PageIndex = m_pageNumber;
                    r = (r - nNewItemIndex * m_pageNumber);
                    dg.EditIndex = r;
                }
                GridTable.Rows.Add(NewRow);
                GridTable.AcceptChanges();
                dg.DataSource = GridTable;
                dg.DataBind();
                k_blnIsAddingNew = true;
            }
            catch (Exception exp)
            {
                DivError.Visible = true;
                _LblError.Text = exp.Message;
            }
        }

        public static bool dgRowDeleting(int _OpCode, string SpName, string _RecFieldID, string _RecFieldValue, ref HtmlGenericControl DivError, ref Label _LblError)
        {
            bool _isretval = false;
            try
            {
                string g_strErrorMessage = "";

                GeneralBL.Delete(_OpCode, SpName, _RecFieldID, _RecFieldValue, ref g_strErrorMessage, "");
                if (g_strErrorMessage.Length > 0)
                {
                    DivError.Visible = true;
                    _LblError.Text = g_strErrorMessage.Replace("Error : ", "");
                }
                else
                {
                    _isretval = true;
                }

            }
            catch (Exception exp)
            {
                DivError.Visible = true;
                _LblError.Text = exp.Message;
            }
            return _isretval;
        }

        public static bool dgRowDeleting(int _OpCode, string SpName, string _RecFieldID, ref GridView dg, ref GridViewDeleteEventArgs e, ref HtmlGenericControl DivError, ref Label _LblError)
        {
            bool _isretval = false;
            try
            {
                string g_strErrorMessage = "";
                if (GeneralBL.isEmptyorNull(dg.DataKeys[e.RowIndex].Value) != "")
                {
                    GeneralBL.Delete(_OpCode, SpName, _RecFieldID, Convert.ToInt32(dg.DataKeys[e.RowIndex].Value), ref g_strErrorMessage, "");
                    if (g_strErrorMessage.Length > 0)
                    {
                        DivError.Visible = true;
                        _LblError.Text = g_strErrorMessage.Replace("Error : ", "");
                    }
                    else
                    {
                        _isretval = true;
                    }
                }
                else
                {
                    DivError.Visible = true;
                    _LblError.Text = "No Record Found to delete.";
                }
            }
            catch (Exception exp)
            {
                DivError.Visible = true;
                _LblError.Text = exp.Message;
            }
            return _isretval;
        }

        public static void dgSerialRowDataBound(string lblid, ref object sender, ref GridView dg, ref GridViewRowEventArgs e, ref int k_intTotalRowsNumbers)
        {
            Label lblSerialNo = (Label)e.Row.FindControl(lblid);
            if (lblSerialNo != null)
            {
                if (e.Row.RowIndex != -1)
                {
                    if (e.Row.RowIndex < k_intTotalRowsNumbers)
                    {
                        lblSerialNo.Text = Convert.ToString((e.Row.RowIndex + (dg.PageSize * dg.PageIndex + 1)));
                    }
                }
            }
        }

      
        public static void dgPageIndexChanging(ref GridView dg, ref GridViewPageEventArgs e, ref HtmlGenericControl DivError, ref Label _LblError)
        {
            DivError.Visible = false;
            _LblError.Text = "";
            try
            {
                dg.PageIndex = e.NewPageIndex;
                dg.EditIndex = -1;
            }
            catch (Exception exp)
            {
                DivError.Visible = true;
                _LblError.Text = exp.Message;
            }
        }



        // Fill Grid New Version
        public static void FillDirectGrid(int OpCode, string _spName, ref HtmlGenericControl DivError, ref Label _LblError, ref GridView dg, ref int k_intTotalRowsNumbers, int EditCol, int delcol)
        {
            try
            {
                string g_strErrorMessage = "";
                DivError.Visible = false;
                _LblError.Text = "";
                dg.DataSource = null;
                dg.DataBind();
                DataTable dt = GeneralBL.FillDataGrid(OpCode, _spName, ref g_strErrorMessage, "2");
                if (g_strErrorMessage.Length < 1)
                {
                    if (GeneralBL.isdtEmptyNull(dt) == true)
                    {
                        if (EditCol != -1)
                        {
                            dg.Columns[EditCol].Visible = true;
                        }
                        if (delcol != -1)
                        {
                            dg.Columns[delcol].Visible = true;
                        }
                        k_intTotalRowsNumbers = dt.Rows.Count;
                    }
                    dg.DataSource = dt;
                    dg.DataBind();
                }
                else
                {
                    DivError.Visible = true;
                    _LblError.Text = g_strErrorMessage.Replace("Error : ", "");
                }
            }
            catch (Exception exp)
            {
                DivError.Visible = true;
                _LblError.Text = exp.Message;
            }
        }


        public static void dgRowCreated(ref object sender, ref GridViewRowEventArgs e, int ColumnSpan)
        {
            if (e.Row.RowType == DataControlRowType.Header)
            {
                GridView gdqueue = (GridView)sender;
                GridViewRow gdrow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Edit);
                LinkButton hpadd2 = new LinkButton();
                hpadd2.CommandName = "New";
                hpadd2.ToolTip = "Click here for Add New Record";
                hpadd2.Text = "Add New&nbsp;";
                hpadd2.CssClass = "btn btn-info";
                hpadd2.CausesValidation = false;
                TableCell tableCell = new TableCell();
                tableCell.Controls.Add(hpadd2);
                tableCell.HorizontalAlign = HorizontalAlign.Right;
                tableCell.ColumnSpan = ColumnSpan;
                tableCell.CssClass = "SBHeader";
                tableCell.ID = "ID1";
                gdrow.Cells.Add(tableCell);
                gdqueue.Controls[0].Controls.AddAt(0, gdrow);
            }
        }


        public static void dgRowDataBound(ref GridViewRowEventArgs e)
        {
            e.Row.BackColor = System.Drawing.Color.FromName("#FFFFFF");
            e.Row.Attributes.Add("OnMouseOver", "this.style.backgroundColor  = '#F0F0F0';");
            e.Row.Attributes.Add("OnMouseOut", "this.style.backgroundColor = '#FFFFFF';");

        }

    }
}