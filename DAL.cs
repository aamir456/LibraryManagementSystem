using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibraryManagementSystem
{

    
    public class DAL
    {
        SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["Connection"].ConnectionString);
        public void ExecuteTable()
        {
            connection.Open();
            SqlCommand cmd = new SqlCommand();
            DataTable dt = new DataTable();
        }
    }
}