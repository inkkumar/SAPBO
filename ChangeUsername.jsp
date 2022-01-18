<%@ page import="com.crystaldecisions.sdk.framework.CrystalEnterprise" %>
<%@ page import="com.crystaldecisions.sdk.framework.ISessionMgr" %>
<%@ page import="com.crystaldecisions.sdk.framework.IEnterpriseSession" %>
<%@ page import="com.crystaldecisions.sdk.occa.infostore.IInfoStore" %>
<%@ page import="com.crystaldecisions.sdk.occa.infostore.IInfoObjects" %>
<%@ page import="com.crystaldecisions.sdk.plugin.desktop.user.IUser" %>
<%@ page import="com.crystaldecisions.sdk.exception.SDKException" %>

<%
    // Retrieve the logon information
    String boCmsName  = request.getParameter("cmsName");
    String boUsername = request.getParameter("userName");
    String boPassword = request.getParameter("password");
    String boAuthType = request.getParameter("authType");
    
    // Retrieve change information
    String oldUserName = request.getParameter("oldName");
    String newUserName = request.getParameter("newName");
    
    IEnterpriseSession oEnterpriseSession = null;

    out.println( "<H2>Change BOE User name</H2><br>" ) ;

    if ( oldUserName.equals( "" ) ) {
       out.print("<FONT COLOR=RED><B>Original username not provided.</B></FONT><br>");
       return;
    }

    if ( newUserName.equals( "" ) ) {
       out.print("<FONT COLOR=RED><B>New username not provided.</B></FONT><br>");
       return;
    }



    // Log in.
    out.println( "logging into " + boCmsName + "...</B><br>" ) ;
    oEnterpriseSession = CrystalEnterprise.getSessionMgr().logon( boUsername, boPassword,
                                                                  boCmsName,  boAuthType );
    if ( oEnterpriseSession == null ) {
       out.print("<FONT COLOR=RED><B>Unable to login.</B></FONT><br>");
       return ;
    }
   
   
    // get user object
    IInfoStore oInfoStore = (IInfoStore) oEnterpriseSession.getService( "", "InfoStore");
    
    String         query          = null ;
    IInfoObjects   oInfoObjects   = null ;
    IUser          oIUser         = null ;
   
    query = "SELECT SI_ID, SI_NAME "
            + "FROM  CI_SYSTEMOBJECTS "
            + "WHERE SI_PROGID='CrystalEnterprise.USER'"
            + "AND   SI_NAME='" + oldUserName + "'" ;
              
    oInfoObjects = (IInfoObjects) oInfoStore.query(query) ;
   
    if ( oInfoObjects.size() == 0 ) {
       // no more objects
       out.println( "<b>Original user name not found: '" + oldUserName + "'</B><br>" ) ;
       return ;
    }
   
    
    oIUser = (IUser) oInfoObjects.get(0);
    out.println(oIUser.getID() + ": '" + oIUser.getTitle() + "' -> '" + newUserName + "'<BR>"); // verbose
   
    try {
       oIUser.setTitle( newUserName ) ;
       oIUser.save() ;
       
    } catch ( SDKException e ) {
       out.print( "<FONT COLOR=RED><B>couldn't new user name.</B></FONT><br>");
       out.println( e.toString() );
       return ;
    }
    
    out.println( "username changed<br>" ) ;
%>

