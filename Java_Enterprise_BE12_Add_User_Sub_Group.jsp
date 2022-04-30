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
<title>Add User Sub Group</title>
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
	IInfoObjects SubGroupInfoObjects=null;
	IInfoObjects ParentGroupInfoObjects=null;
	IInfoObject SubGroupInfoObject=null;
	IInfoObject ParentGroupInfoObject=null;
	IUserGroup parentGroup = null;
	int SubGroupID;
	
	SDKException failure = null;
	IEnterpriseSession boEnterpriseSession = null;
   
   try{
   	    // Logon and obtain an Enterprise Session
    	boEnterpriseSession = CrystalEnterprise.getSessionMgr().logon( boUser, boPassword, boCmsName, boAuthType);

        boInfoStore = (IInfoStore) boEnterpriseSession.getService("", "InfoStore");

       //get subGroup's ID
        SubGroupInfoObjects = boInfoStore.query("SELECT SI_ID FROM CI_SYSTEMOBJECTS WHERE SI_PROGID='CrystalEnterprise.USERGROUP' and SI_Name='TestSubGroup'");
        SubGroupInfoObject=(IInfoObject)SubGroupInfoObjects.get(0);
        SubGroupID=SubGroupInfoObject.getID();

        // get the parent group
        ParentGroupInfoObjects=boInfoStore.query("SELECT * FROM CI_SYSTEMOBJECTS WHERE SI_PROGID='CrystalEnterprise.USERGROUP' and SI_Name='New User Group'");
        ParentGroupInfoObject=(IInfoObject)ParentGroupInfoObjects.get(0);

        //add the subgroup to the parent group
        parentGroup=(IUserGroup)ParentGroupInfoObject;
        parentGroup.getSubGroups().add(new Integer(SubGroupID));

        //Commit the changes to the InfoStore.
        boInfoStore.commit(ParentGroupInfoObjects);        
        out.println("The User Group has been added as a sub-group!");
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
