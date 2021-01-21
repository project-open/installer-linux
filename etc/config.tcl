###################################################################### 
#
# ]project-open[ V5.1 Configuration File
#
# - Using PostgreSQL 10.x
# - Using OpenACS 5.9.1
# - Using Naviserver 4.99.8
# - Assuming systemctl configuration
# 
###################################################################### 
ns_log notice "config.tcl as po51demo: executing config file... "

#---------------------------------------------------------------------
# Web server ports. Change to 80 and 443 for production use or
# use "Pound" as a reverse proxy.
# If setting httpport below 1024 then please read comments in file:
# /var/lib/aolserver/service0/packages/etc/daemontools/run
#
set httpport		8000
set httpsport		8443 


# Please enter the fully qualified hostname.
# hostname is now (]po[ V5.1 and higher) used for redirection.
#set hostname		[ns_info hostname]
set hostname		"project-open.project-open.com"

# listen address for Web server
set address		"0.0.0.0"

set server		projop
set servername		"\]project-open\[ V5.1"
set serverroot		/web/${server}
set logroot		$serverroot/log/

# Home directory of AOLserver
set homedir		/usr/local/ns
set bindir		${homedir}/bin

# Are we runnng behind a proxy?
set proxy_mode          true

# Which database do you want? postgres or oracle
# The name of the database is the same as the server by default.
set database		postgres 
set db_name		$server

# Hard limits for up- and downloads
set max_file_upload_mb	200
set max_file_upload_min	5

# Debug is turned on for demo servers. Please turn off for
# performance critical production installations.
set debug		true
set dev			false


###################################################################### 
#
# End of instance-specific settings 
#
# Nothing below this point need be changed in a default install.
#
###################################################################### 

#---------------------------------------------------------------------
# Database specific settings
set db_host		localhost
set db_port		"5432"
set db_user		$server

#---------------------------------------------------------------------
# set environment variables HOME and LANG
set env(HOME) $homedir
set env(LANG) en_US.UTF-8

#---------------------------------------------------------------------
# AOLserver's directories. Autoconfigurable. 
#---------------------------------------------------------------------
# Where are your pages going to live ?
set pageroot			${serverroot}/www 
set directoryfile		"index.tcl index.adp index.html index.htm"

#---------------------------------------------------------------------
# Global server parameters 
#---------------------------------------------------------------------
ns_section ns/parameters 
	ns_param	 serverlog		${logroot}/error.log 
	ns_param	 pidfile		${logroot}/nsd.pid
	ns_param	 home			$homedir 
	ns_param	 debug			$debug

	ns_param	 logroll		on
	ns_param	 logmaxbackup		100
	ns_param	 logdebug		$debug
	ns_param	 logdev			$dev

	# setting to Unicode by default
	# see http://dqd.com/~mayoff/encoding-doc.html
	# ns_param	 HackContentType	1	 

	# Naviserver's defaults charsets are all utf-8.  Allthough the
	# default charset is utf-8, set the parameter "OutputCharset"
	# here, since otherwise OpenACS uses in the meta-tags the charset
	# from [ad_conn charset], which is taken from the db and
	# per-default ISO-8859-1.
	ns_param	OutputCharset	utf-8   
	# ns_param	URLCharset	utf-8

	# Running behind proxy? Used by OpenACS...
	ns_param	ReverseProxyMode	$proxy_mode

#---------------------------------------------------------------------
# Thread library (nsthread) parameters 
#---------------------------------------------------------------------
ns_section ns/threads 
	#ns_param	 mutexmeter		true	;# measure lock contention 
	# The per-thread stack size must be a multiple of 8k for 
	# AOLServer to run under MacOS X
	ns_param	 stacksize		[expr {128 * 8192}]

# 
# MIME types. 
# 
ns_section ns/mimetypes
	# Note: AOLserver already has an exhaustive list of MIME types:
	# see: /usr/local/src/aolserver-4.{version}/aolserver/nsd/mimetypes.c
	# but in case something is missing you can add it here. 
	ns_param	Default			*/*
	ns_param	NoExtension		*/*
	ns_param	.pcd			image/x-photo-cd
	ns_param	.prc			application/x-pilot
	ns_param	.xls			application/vnd.ms-excel
	ns_param	.doc			application/vnd.ms-word
	ns_param	.docm			application/vnd.ms-word.document.macroEnabled.12
	ns_param	.docx			application/vnd.openxmlformats-officedocument.wordprocessingml.document
	ns_param	.dotm			application/vnd.ms-word.template.macroEnabled.12
	ns_param	.dotx			application/vnd.openxmlformats-officedocument.wordprocessingml.template
	ns_param	.potm			application/vnd.ms-powerpoint.template.macroEnabled.12
	ns_param	.potx			application/vnd.openxmlformats-officedocument.presentationml.template
	ns_param	.ppam			application/vnd.ms-powerpoint.addin.macroEnabled.12
	ns_param	.ppsm			application/vnd.ms-powerpoint.slideshow.macroEnabled.12
	ns_param	.ppsx			application/vnd.openxmlformats-officedocument.presentationml.slideshow
	ns_param	.pptm			application/vnd.ms-powerpoint.presentation.macroEnabled.12
	ns_param	.pptx			application/vnd.openxmlformats-officedocument.presentationml.presentation
	ns_param	.xlam			application/vnd.ms-excel.addin.macroEnabled.12
	ns_param	.xlsb			application/vnd.ms-excel.sheet.binary.macroEnabled.12
	ns_param	.xlsm			application/vnd.ms-excel.sheet.macroEnabled.12
	ns_param	.xlsx			application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
	ns_param	.xltm			application/vnd.ms-excel.template.macroEnabled.12
	ns_param	.xltx			application/vnd.openxmlformats-officedocument.spreadsheetml.template

#---------------------------------------------------------------------
# 
# Server-level configuration 
# 
#	There is only one server in AOLserver, but this is helpful when multiple
#	servers share the same configuration file.	This file assumes that only
#	one server is in use so it is set at the top in the "server" Tcl variable
#	Other host-specific values are set up above as Tcl variables, too.
# 
#---------------------------------------------------------------------
ns_section ns/servers 
	ns_param	 $server		$servername 

# 
# Server parameters 
# 
ns_section ns/server/${server} 
	#
	# Scaling and Tuning Options
	#
	ns_param	maxconnections	100	;# 100; number of allocated connection stuctures
	ns_param	maxthreads	10	;# 10; maximal number of connection threads
	ns_param	minthreads	2	;# 1; minimal number of connection threads
	ns_param	connsperthread	10000	;# 10000; number of connections (requests) handled per thread
	ns_param	highwatermark	100     ;# 80; allow concurrent creates above this queue-is percentage
                                                ;# 100 means to disable concurrent creates

	# Compress response character data: ns_return, ADP etc.
	#
	ns_param	compressenable	false	;# "false" for off, "on" for on, use "ns_conn compress" to override
	# ns_param	compresslevel	4	;# 4, 1-9 where 9 is high compression, high overhead
        # ns_param	compressminsize	512	;# Compress responses larger than this
        # ns_param   	compresspreinit true	;# false, if true then initialize and allocate buffers at startup

	#
	# Special HTTP pages
	#
	ns_param	 NotFoundResponse	"/global/file-not-found.html"
	ns_param	 ServerBusyResponse	"/global/busy.html"
	ns_param	 ServerInternalErrorResponse "/global/error.html"


# Special HTTP pages
#
ns_section ns/server/${server}/redirects
	ns_param	404	"/global/file-not-found.html"
	ns_param	403	"/global/forbidden.html"
	ns_param	503	"/global/busy.html"
	ns_param	500	"/global/error.html"


#---------------------------------------------------------------------
# 
# ADP (AOLserver Dynamic Page) configuration 
# 
#---------------------------------------------------------------------
ns_section ns/server/${server}/adp 
	ns_param	 map			/*.adp	;# Extensions to parse as ADP's 
	ns_param	 enableexpire		 false	 ;# Set "Expires: now" on all ADP's 

ns_section ns/server/${server}/adp/parsers
	ns_param	 fancy			".adp"

ns_section ns/server/${server}/redirects
	ns_param	 404			"global/file-not-found.html"
	ns_param	 403			"global/forbidden.html"

# 
# Tcl Configuration 
# 
ns_section ns/server/${server}/tcl
	ns_param	 library		${serverroot}/tcl
	ns_param	 autoclose		on 
	ns_param	 debug			$debug


ns_section "ns/server/${server}/fastpath"
	ns_param	serverdir	${homedir}
	ns_param	pagedir		${pageroot}
	#
	# Directory listing options
	#
	# ns_param	directoryfile		"index.adp index.tcl index.html index.htm"
	# ns_param	directoryadp		$pageroot/dirlist.adp ;# Choose one or the other
	# ns_param	directoryproc		_ns_dirlist           ;#  ...but not both!
	# ns_param	directorylisting	fancy                 ;# Can be simple or fancy
	#


 
#---------------------------------------------------------------------
#
# Rollout email support
#
# These procs help manage differing email behavior on 
# dev/staging/production.
#
#---------------------------------------------------------------------
ns_section ns/server/${server}/acs/acs-rollout-support

	# EmailDeliveryMode can be:
	#	 default:	Email messages are sent in the usual manner.
	#	 log:		Email messages are written to the server's error log.
	#	 redirect: Email messages are redirected to the addresses specified 
	#	by the EmailRedirectTo parameter.	If this list is absent 
	#	or empty, email messages are written to the server's error log.
	#	 filter:	 Email messages are sent to in the usual manner if the 
	#	recipient appears in the EmailAllow parameter, otherwise they 
	#	are logged.

#	ns_param	 EmailDeliveryMode 	redirect
#	ns_param	 EmailRedirectTo	somenerd@yourdomain.test, othernerd@yourdomain.test
#	ns_param	 EmailAllow		somenerd@yourdomain.test,othernerd@yourdomain.test

#---------------------------------------------------------------------
#
# WebDAV Support (optional, requires oacs-dav package to be installed
#
#---------------------------------------------------------------------
ns_section ns/server/${server}/tdav
	ns_param propdir 		${serverroot}/data/dav/properties
	ns_param lockdir 		${serverroot}/data/dav/locks
	ns_param defaultlocktimeout	300

ns_section ns/server/${server}/tdav/shares
	ns_param share1 		"OpenACS"
#	ns_param share2 		"Share 2 description"

ns_section ns/server/${server}/tdav/share/share1
	ns_param uri 			"/dav/*"
	# all WebDAV options
	ns_param options 		"OPTIONS COPY GET PUT MOVE DELETE HEAD MKCOL POST PROPFIND PROPPATCH LOCK UNLOCK"

#ns_section ns/server/${server}/tdav/share/share2
#	ns_param uri 			"/share2/path/*"
	# read-only WebDAV options
#	ns_param options 		"OPTIONS COPY GET HEAD MKCOL POST PROPFIND PROPPATCH"


#---------------------------------------------------------------------
# 
# Socket driver module (HTTP)	-- nssock 
# 
#---------------------------------------------------------------------
ns_section ns/server/${server}/module/nssock
	ns_param	 address	$address
	ns_param	 hostname	$hostname
	ns_param	 port   	$httpport
	ns_param	 maxinput	[expr {$max_file_upload_mb * 1024 * 1024}] ;# Maximum File Size for uploads in bytes
	ns_param	 maxpost	[expr {$max_file_upload_mb * 1024 * 1024}] ;# Maximum File Size for uploads in bytes
	ns_param	 recvwait	[expr {$max_file_upload_min * 60}] ;# Maximum request time in minutes


	# Spooling Threads
	#
	# ns_param	spoolerthreads	1	;# 0, number of upload spooler threads
	# ns_param	maxupload	0	;# 0, when specified, spool uploads larger than this value to a temp file
	ns_param	writerthreads	2	;# 0, number of writer threads
	ns_param	writersize	4096	;# 1024*1024, use writer threads for files larger than this value
	# ns_param	writerbufsize	8192	;# 8192, buffer size for writer threads
	# ns_param	writerstreaming	true	;# false;  activate writer for streaming HTML output (when using ns_write)



# On Windows you need to set this parameter to define the number of
# connections as well (it seems).
#	ns_param	 backlog	5	;# if < 1 == 5 


#---------------------------------------------------------------------
# 
# Access log -- nslog 
# 
#---------------------------------------------------------------------
ns_section ns/server/${server}/module/nslog 
	ns_param	file		${serverroot}/log/${server}.log
	ns_param	rollfmt		%Y-%m-%d-%H:%M
	ns_param	logpartialtimes	true   ;# false, include high-res start time
	ns_param	checkforproxy	$proxy_mode ;# false, check for proxy header (X-Forwarded-For)


#---------------------------------------------------------------------
#
# PAM authentication
#
#---------------------------------------------------------------------
ns_section ns/server/${server}/module/nspam
	ns_param	 PamDomain	"pam_domain"


#---------------------------------------------------------------------
#
# SSL
# 
#---------------------------------------------------------------------

ns_section    "ns/server/${server}/module/nsssl"
       ns_param		address    	$address
       ns_param		port       	$httpsport
       ns_param		hostname       	$hostname
       ns_param		ciphers		"ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!RC4"
       ns_param		protocols	"!SSLv2"
       ns_param		certificate	$serverroot/etc/certfile.pem
       ns_param		verify     	0
       ns_param		writerthreads	2
       ns_param		writersize	4096
       ns_param		writerbufsize	16384	;# 8192, buffer size for writer threads
       #ns_param	writerstreaming	true	;# false
       #ns_param	deferaccept	true    ;# false, Performance optimization
       ns_param		maxinput	[expr {$max_file_upload_mb * 1024*1024}] ;# Maximum File Size for uploads in bytes



#---------------------------------------------------------------------
# 
# Database drivers 
# The database driver is specified here.
# Make sure you have the driver compiled and put it in {aolserverdir}/bin
#
#---------------------------------------------------------------------
ns_section "ns/db/drivers" 
ns_param	 postgres		 ${bindir}/nsdbpg.so


# Database Pools: This is how AOLserver	``talks'' to the RDBMS. You need 
# three for OpenACS: main, log, subquery. Make sure to replace ``yourdb'' 
# and ``yourpassword'' with the actual values for your db name and the 
# password for it, if needed.	
#
# AOLserver can have different pools connecting to different databases 
# and even different different database servers.	See
# http://openacs.org/doc/openacs-5-1/tutorial-second-database.html

ns_section ns/db/pools 
	ns_param	 pool1	"Pool 1"
	ns_param	 pool2	"Pool 2"
	ns_param	 pool3	"Pool 3"

ns_section ns/db/pool/pool1
	ns_param	 connections		15
	ns_param	 verbose		$debug
	ns_param	 extendedtableinfo	true
	ns_param	 logsqlerrors		$debug
	ns_param	 driver			postgres 
	ns_param	 datasource		${db_host}:${db_port}:${db_name}
	ns_param	 user			$db_user
	ns_param	 password		""


ns_section ns/db/pool/pool2
	ns_param	 connections		5
	ns_param	 verbose		$debug
	ns_param	 extendedtableinfo	true
	ns_param	 logsqlerrors		$debug
	ns_param	 driver			postgres 
	ns_param	 datasource		${db_host}:${db_port}:${db_name}
	ns_param	 user			$db_user
	ns_param	 password		""


ns_section ns/db/pool/pool3
	ns_param	 connections		5
	ns_param	 verbose		$debug
	ns_param	 extendedtableinfo	true
	ns_param	 logsqlerrors		$debug
	ns_param	 driver			postgres 
	ns_param	 datasource		${db_host}:${db_port}:${db_name}
	ns_param	 user			$db_user
	ns_param	 password		""


ns_section ns/server/${server}/db
	ns_param	 pools			pool1,pool2,pool3
	ns_param	 defaultpool		pool1


#---------------------------------------------------------------------
# which modules should be loaded? Missing modules break the server, so
# don't uncomment modules unless they have been installed.
ns_section ns/server/${server}/modules 
	ns_param	 nssock			${bindir}/nssock.so 
	ns_param	 nslog			${bindir}/nslog.so 
	ns_param	 nsdb			${bindir}/nsdb.so
	ns_param	 nsproxy		${bindir}/nsproxy.so
	# ns_param	 nssha1			${bindir}/nssha1.so 

	#
	# Determine, if libthread is installed
	#
        set libthread [lindex [glob -nocomplain $homedir/lib/thread*/libthread*[info sharedlibextension]] end]
	if {$libthread eq ""} {
	  ns_log notice "No Tcl thread library installed in $homedir/lib/"
	} else {
	  ns_param	libthread $libthread
	  ns_log notice "Use Tcl thread library $libthread"
	}

	# authorize-gateway package requires dqd_utils
	# ns_param	dqd_utils dqd_utils[expr {int($tcl_version)}].so

	# PAM authentication
	# ns_param	nspam              ${bindir}/nspam.so

	# LDAP authentication
	# ns_param	nsldap             ${bindir}/nsldap.so

	# These modules aren't used in standard OpenACS installs
	# ns_param	nsperm             ${bindir}/nsperm.so 
	# ns_param	nscgi              ${bindir}/nscgi.so 
	# ns_param	nsjava             ${bindir}/libnsjava.so
	# ns_param	nsrewrite          ${bindir}/nsrewrite.so 


#
# nsproxy configuration
#

ns_section ns/server/${server}/module/nsproxy
	# ns_param	maxslaves          8
	# ns_param	sendtimeout        5000
	# ns_param	recvtimeout        5000
	# ns_param	waittimeout        1000
	# ns_param	idletimeout        300000

ns_log notice "nsd.tcl: using threadsafe tcl: [info exists tcl_platform(threaded)]"
ns_log notice "nsd.tcl: finished reading config file."

