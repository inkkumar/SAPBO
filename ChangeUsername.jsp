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
    String boPassword = "Flexrep@dm1n!";
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
            + "AND   SI_NAME IN ('pvanhoe',  'GO_010',  'tpeeters' ,  'mvdstraete' ,  'espooren' ,  'hvanwinckel', 'rlincer', 'plemmens', 'Vlonnoy', 'Ydegirmenci', 'Mmolinari', 'rhiel', 'ddobbelaere', 'sgabriels', 'gdkeyser', 'dmoulart', 'elermytte', 'jjacques', 'gverheyden', 'gvanpassel', 'jdecanniere', 'jdepuydt', 'gdams', 'gcamerlinck', 'pjacobus', 'anprovenzano', 'wroelens', 'cvanlooy', 'ecremers', 'lnauwelaerts', 'kbollaert', 'dmorreel', 'hreynaerts', 'hdejaeger', 'hboel', 'iverbruggen_pub', 'kclaes', 'ldemoor', 'meyckmans', 'pbuntinx_pub', 'pdepril', 'rboonen', 'sloonbeek', 'sdelove', 'wvancappellen', 'vdockx', 'dvanhoutte', 'bryckmans', 'lsalliau', 'bvanwynsberghe', 'lgorissen', 'ndaenen', 'dvanast', 'dproost', 'jdewaele', 'kseghers', 'tboussu', 'dvanloon', 'GO_nseverens', 'bgryson', 'GO_sbauwens', 'phennes', 'jwayenberg', 'kmeeus', 'emichotte', 'sbrynaert', 'cdesmul', 'ddenbaes', 'vdemerlier', 'cvandecasteele', 'GO_mvanmulders', 'mpels', 'GO_jkessels', 'gvannoten', 'jdaemen', 'astuyvaert', 'vhenderix', 'jpenders', 'gschoofs', 'cjvictoor', 'kdewickere', 'pschoonheydt', 'GO_gdemeestere', 'icuyt', 'GO_mcs_sgr_beheerder', 'acetina', 'evermeulen', 'mvanstrydonck', 'twilrycx', 'glemmens', 'btestsgr3', 'GO_lho', 'GO_fdemeulemeester', 'cgysens', 'asmeyers', 'cromswinkel', 'ewillems', 'lpouls', 'bverhaevert', 'GO_kp', 'GO_simschoot', 'GO_cvanderbeeck', 'jvercruysse', 'ndecaluwe', 'GO_ehelsen', 'slelievre', 'GO_hvdstrae', 'GO_enoels', 'GO_minnie', 'GO_sgr23_beheerder', 'GO_sgr16_melder', 'GO_eeerdekens', 'GO_gwils', 'GO_ageudens', 'GO_hvandeveire', 'GO_yheylen', 'GO_sgr01_beheerder', 'GO_sgr08_beheerder', 'GO_pverberckmoes', 'CD_aa', 'GO_gwieme', 'GO_jvanrooy', 'GO_Mailagent', 'GO_iverbruggen_pub', 'GO_ipeleman', 'GO_dpeirsman', 'FVS', 'GO_swyseur', 'GO_adeceuninck')" ;
              
    oInfoObjects = (IInfoObjects) oInfoStore.query(query) ;
   
    if ( oInfoObjects.size() == 0 ) {
       // no more objects
       out.println( "<b>Original user name not found: '" + oldUserName + "'</B><br>" ) ;
       return ;
    }
   
    
    oIUser = (IUser) oInfoObjects.get(0);
    out.println(oIUser.getID() + ": '" + oIUser.getTitle() + "' -> '" + newUserName + "'<BR>"); // verbose
   
    try {
		for(int i = 0; i < 80; i+=1)
			{
			    oIUser = (IUser) oInfoObjects.get(i);
				out.println(   (IUser) oInfoObjects.get(i));
				oIUser.setTitle( oIUser.getTitle()  + "_dup" ) ;
				oIUser.save() ;
			}
       
    } catch ( SDKException e ) {
       out.print( "<FONT COLOR=RED><B>couldn't new user name.</B></FONT><br>");
       out.println( e.toString() );
       return ;
    }
    
    out.println( "username changed<br>" ) ;
%>

