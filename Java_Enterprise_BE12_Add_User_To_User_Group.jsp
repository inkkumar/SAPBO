<%@ page import = "com.crystaldecisions.sdk.framework.*"%>
<%@ page import = "com.crystaldecisions.sdk.exception.*"%>
<%@ page import = "com.crystaldecisions.sdk.occa.infostore.*"%>
<%@ page import = "com.crystaldecisions.sdk.occa.security.*"%>
<%@ page import = "com.crystaldecisions.sdk.occa.pluginmgr.*"%>
<%@ page import = "com.crystaldecisions.sdk.plugin.desktop.user.*"%>
<%@ page import = "com.crystaldecisions.sdk.plugin.desktop.usergroup.*"%>
<%@ page import = " com.crystaldecisions.sdk.plugin.desktop.common.*"%>
<%@ page import = "java.util.*"%>

<html>
<head>
<title>Add User to User Group</title>
</head>
<body>

<%
	// Set the logon information
    String boUser = "Administrator";
    String boPassword = "";
    String boCmsName = "localhost";
    String boAuthType = "secEnterprise";

	// Declare Variables
    IInfoStore boInfoStore=null;
	IInfoObjects boInfoObjects=null;
	SDKException failure = null;
	IEnterpriseSession boEnterpriseSession = null;
   	
   	IUser boCurUser = null;
   	IUserGroup boGroup = null;
   	
    
   try{
   	    // Logon and obtain an Enterprise Session
    	boEnterpriseSession = CrystalEnterprise.getSessionMgr().logon( boUser, boPassword, boCmsName, boAuthType);

        boInfoStore = (IInfoStore) boEnterpriseSession.getService("", "InfoStore");
    	
		// Retrieve the user and group
		boInfoObjects = boInfoStore.query("SELECT SI_ID From CI_SYSTEMOBJECTS Where SI_PROGID='CrystalEnterprise.User' and SI_NAME = 'Guest'");
		boCurUser = (IUser)boInfoObjects.get(0);
        boGroup = (IUserGroup)boInfoStore.query("SELECT * FROM CI_SYSTEMOBJS WHERE SI_PROGID='CrystalEnterprise.USERGROUP' AND SI_NAME='New User Group'").get(0);
                
	    boCurUser.getGroups().add(new Integer(boGroup.getID()));
        
        //Commit the changes to the InfoStore.
        boInfoStore.commit(boInfoObjects);
        out.println("User has been added to group!");
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
