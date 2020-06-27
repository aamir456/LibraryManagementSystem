using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using BLLV2;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;

namespace LibraryManagementSystem
{
    public partial class BookReport : System.Web.UI.Page
    {


      
        private string g_strErrorMessage = "";
        private string g_strErrorType = "";
        private string _PrimaryFieldValue = "-1";
        private string RptTypeid = "";
        private string FromDate = "";
        private string ToDate = "";

        protected void Page_Load(object sender, EventArgs e)
        {
           
        }
        protected void Page_Init(object sender, EventArgs e)
        {
            DivError.Visible = false;
            lblError.Text = "";


            // ComplaintID RptTypeid
            //
            if (Request.QueryString["RpTypeid"].ToString() != "")
            {
                RptTypeid = Request.QueryString["RpTypeid"].ToString();
            }
            if (Request.QueryString["From"].ToString() != "")
            {
                FromDate = Request.QueryString["From"].ToString();
            }
            if (Request.QueryString["To"].ToString() != "")
            {
                ToDate = Request.QueryString["To"].ToString();
            }

            //if ((Request["en"]) != null)
            //{
            //    //EncQStr qs = new EncQStr(Request["en"]);
            //    //if (GeneralBL.isEmptyorNull(qs["ID"]) != "")
            //    //{
            //    //    _PrimaryFieldValue = GeneralBL.isEmptyorNull(qs["ID"]);
            //    //}
            //    //if (GeneralBL.isEmptyorNull(qs["RptTypeid"]) != "")
            //    //{
            //    //    RptTypeid = GeneralBL.isEmptyorNull(qs["RptTypeid"]);
            //    //}
            //    //if (GeneralBL.isEmptyorNull(qs["From"]) != "")
            //    //{
            //    //    FromDate = GeneralBL.isEmptyorNull(qs["From"]);
            //    //}
            //    //if (GeneralBL.isEmptyorNull(qs["To"]) != "")
            //    //{
            //    //    ToDate = GeneralBL.isEmptyorNull(qs["To"]);
            //    //}
            //    //if (GeneralBL.isEmptyorNull(qs["Supplier"]) != "")
            //    //{
            //    //    Supplier = GeneralBL.isEmptyorNull(qs["Supplier"]);
            //    //}
            //    //if (GeneralBL.isEmptyorNull(qs["Location"]) != "")
            //    //{
            //    //    Location = GeneralBL.isEmptyorNull(qs["Location"]);
            //    //}
            //    //if (GeneralBL.isEmptyorNull(qs["Category"]) != "")
            //    //{
            //    //    Category = GeneralBL.isEmptyorNull(qs["Category"]);
            //    //}
            //    //if (GeneralBL.isEmptyorNull(qs["SubCategory"]) != "")
            //    //{
            //    //    SubCategory = GeneralBL.isEmptyorNull(qs["SubCategory"]);
            //    //} 
            //    //if (GeneralBL.isEmptyorNull(qs["Items"]) != "")
            //    //{
            //    //    Items = GeneralBL.isEmptyorNull(qs["Items"]);
            //    //}

            //}


            if (!Page.IsPostBack)
            {
                FillDataGrid();
            }

        }


        private string reportName()
        {
            string _retval = "";
            try
            {

                switch (RptTypeid)
                {
                    case "1":
                        _retval = "Reports/BookReport.rpt";
                        break;
                    case "2":
                        _retval = "Reports/BookIssueReport.rpt";
                        break;
                    case "3":
                        _retval = "Reports/BookReceiveReport.rpt";
                        break;
                }

            }
            catch (Exception exp)
            {

                DivError.Visible = true;
                lblError.Text = exp.Message;
            }
            return _retval;
        }
        private void FillDataGrid()
        {
            try
            {
                string _Procname = "";
                g_strErrorMessage = "";
                vwrReport.ReportSource = null;
                vwrReport.DataBind();
                DataSet _dsreport = new DataSet();
                SqlParameter[] paramstostore;

                switch (RptTypeid)
                {
                    case "1":
                        paramstostore = new SqlParameter[1];
                        paramstostore[0] = new SqlParameter("@OpCode", SqlDbType.Int);
                        paramstostore[0].Value = "1";
                       // myclass.AddParams(1, "BookID", _PrimaryFieldValue, ref paramstostore);
                        _Procname = "SPR_CrystalReports";
                        _dsreport = DataAccess.GetDataSet(_Procname, paramstostore, ref g_strErrorMessage);
                        break;

                    case "2":
                        paramstostore = new SqlParameter[3];
                        paramstostore[0] = new SqlParameter("@OpCode", SqlDbType.Int);
                        paramstostore[0].Value = "2";
                        paramstostore[1] = new SqlParameter("@FromDate", SqlDbType.Date);
                        paramstostore[1].Value = FromDate;
                        paramstostore[2] = new SqlParameter("@ToDate", SqlDbType.Date);
                        paramstostore[2].Value = ToDate;
                        //myclass.AddParams(1, "MemeberID", _PrimaryFieldValue, ref paramstostore);
                        _Procname = "SPR_CrystalReports";
                        _dsreport = DataAccess.GetDataSet(_Procname, paramstostore, ref g_strErrorMessage);
                        break;
                    case "3":
                        paramstostore = new SqlParameter[3];
                        paramstostore[0] = new SqlParameter("@OpCode", SqlDbType.Int);
                        paramstostore[0].Value = "3";
                        paramstostore[1] = new SqlParameter("@FromDate", SqlDbType.Date);
                        paramstostore[1].Value = FromDate;
                        paramstostore[2] = new SqlParameter("@ToDate", SqlDbType.Date);
                        paramstostore[2].Value = ToDate;
                        //myclass.AddParams(1, "MemeberID", _PrimaryFieldValue, ref paramstostore);
                        _Procname = "SPR_CrystalReports";
                        _dsreport = DataAccess.GetDataSet(_Procname, paramstostore, ref g_strErrorMessage);
                        break;


                }

                //Todo: 
                #region ReportFillCode
                // _dsreport = DataAccess.GetDataSet(_Procname, paramstostore, ref g_strErrorMessage);
                if (g_strErrorMessage.Length < 1)
                {
                    if (_dsreport != null)
                    {
                        if (_dsreport.Tables.Count > 0)
                        {
                            if (_dsreport.Tables[0].Rows.Count > 0)
                            {
                                _dsreport.Tables[0].TableName = "GenRptFields";
                                ReportDocument rptDoc = new ReportDocument();
                                rptDoc.Load(Server.MapPath(reportName()));
                                rptDoc.SetDataSource(_dsreport);
                                vwrReport.ReportSource = rptDoc;
                                vwrReport.RefreshReport();
                                vwrReport.DataBind();
                                rptDoc.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, false, "printrpt");
                            }
                            else
                            {
                                vwrReport.ReportSource = null;
                                vwrReport.DataBind();
                                DivError.Visible = true;
                                lblError.Text = "No record(s) found for the specified criteria.";
                            }
                        }
                        else
                        {
                            vwrReport.ReportSource = null;
                            vwrReport.DataBind();
                            DivError.Visible = true;
                            lblError.Text = "No record(s) found for the specified criteria.";
                        }
                    }
                }
                else
                {
                    vwrReport.ReportSource = null;
                    vwrReport.DataBind();
                    DivError.Visible = true;
                    lblError.Text = g_strErrorMessage;
                }


                #endregion

            }
            catch (Exception exp)
            {

                DivError.Visible = true;
                lblError.Text = exp.Message;
            }
        }
    }
}