<%@ page import = "com.crystaldecisions.sdk.framework.*"%>
<%@ page import = "com.crystaldecisions.sdk.exception.*"%>
<%@ page import = "com.crystaldecisions.sdk.occa.infostore.*"%>
<%@ page import = "com.crystaldecisions.sdk.occa.security.*"%>
<%@ page import = "com.crystaldecisions.sdk.occa.pluginmgr.*"%>
<%@ page import = "com.crystaldecisions.sdk.plugin.desktop.user.*"%>
<%@ page import = "com.crystaldecisions.sdk.plugin.desktop.common.*"%>
<%@ page import = "java.util.*"%>



<html>
<head>
<title>List All User Groups for Users</title>
</head>
<body>

<%
	// Set the logon information
    String boUser = "Administrator";
    String boPassword = "Flexrep@dm1n!";
    String boCmsName = "localhost";
    String boAuthType = "secEnterprise";
    // Set some values
    int max_id = 0;

	// Declare Variables
    IInfoStore boInfoStore=null;
	IInfoObjects boInfoObjects=null;
	IInfoObjects boInfoObjects2=null;
	IInfoObject boInfoObject=null;
	Boolean S_IsDisabled = null;
	SDKException failure = null;
	IEnterpriseSession boEnterpriseSession = null;
	    
   	try{
   	    // Logon and obtain an Enterprise Session
    	boEnterpriseSession = CrystalEnterprise.getSessionMgr().logon( boUser, boPassword, boCmsName, boAuthType);
		boInfoStore = (IInfoStore) boEnterpriseSession.getService("", "InfoStore");
   		
    	// Loop through all users
    	for(;;) { 
	        boInfoObjects = (IInfoObjects)boInfoStore.query("SELECT TOP 500 * FROM CI_SYSTEMOBJECTS WHERE SI_KIND = 'User' and SI_ID > " + max_id +  " ORDER BY SI_ID ASC");
	                                               
	        if(boInfoObjects.size() == 0) 
	            break;
			S_IsDisabled  = null;
		    for(Iterator boUsers = boInfoObjects.iterator(); boUsers.hasNext();) {
		   		IUser boUserAccount;
				
		        boUserAccount = (IUser) boUsers.next();
		   //     out.println(boUserAccount.getTitle() + " (" + boUserAccount.getID() + ")<BR>");
				Iterator  boIterator  = boUserAccount.getAliases().iterator();
				while(boIterator.hasNext())
		{
				IUserAlias boAlias = (IUserAlias)boIterator.next();
		//		out.println("current status is: " + boAlias.isDisabled());
				S_IsDisabled = boAlias.isDisabled();
		}
		        // Retrieve all the groups for this user
				java.util.Set boGroups = (java.util.Set)boUserAccount.getGroups();
				out.println("Number of Users : " + boGroups.size() + "<BR>");
				
			//	out.println("Group name: " + (boGroups.toArray()[0]).toString());
	
				 for (int i = 0; i < boGroups.size(); i++) {
					boInfoObjects2 = boInfoStore.query("Select * from CI_SYSTEMOBJECTS where SI_ID = '" + ((Integer)boGroups.toArray()[i]).toString() + "'");
					boInfoObject = (IInfoObject)boInfoObjects2.get(0);
					out.println( boInfoObject.getTitle() + "," + boUserAccount.getTitle() + "," + S_IsDisabled +   "<BR>");
					
		      	} 
			
		      	out.println("<BR>");
		       	max_id = boUserAccount.getID();
	       	}
	   	}
    }    	
    catch(SDKException e)
    {
        out.println(e.getMessage());
    }
    finally
    {
	    boEnterpriseSession.logoff();
    }
%>

</body>
</html>
