<!---
Programmer: Tim McCarthy (tim@timmcc.com)
Date: February, 2003
Description:
	Produces a 128-bit condensed representation of a message (attributes.msg) called
	a message digest (caller.msg_digest) using the RSA MD5 message-digest algorithm
	as specified in RFC 1321 (http://www.ietf.org/rfc/rfc1321.txt)
Required parameter: msg
Optional parameter: format="hex" (hexadecimal, default is ASCII text)
Example syntax: <cf_md5 msg="abcdefghijklmnopqrstuvwxyz">
Output variable: caller.msg_digest
Note:
	This version accepts input in both ASCII text and hexadecimal formats.
	Previous versions did not accept input in hexadecimal format.
--->

<HTML>
<HEAD>
	<TITLE>RSA MD5 Message-Digest Algorithm</TITLE>
</HEAD>

<BODY>

<!--- default value of optional parameter --->
<CFPARAM name="attributes.format" default="">

<!--- convert the msg to ASCII binary-coded form --->
<CFIF attributes.format EQ "hex">
	<CFSET hex_msg = attributes.msg>
<CFELSE>
	<CFSET hex_msg = "">
	<CFLOOP index="i" from="1" to="#Len(attributes.msg)#">
		<CFSET hex_msg = hex_msg & Right("0"&FormatBaseN(Asc(Mid(attributes.msg,i,1)),16),2)>
	</CFLOOP>
</CFIF>

<!--- compute the msg length in bits --->
<CFSET hex_msg_len = Right(RepeatString("0",15)&FormatBaseN(4*Len(hex_msg),16),16)>
<CFSET temp = "">
<CFLOOP index="i" from="1" to="8">
	<CFSET temp = temp & Mid(hex_msg_len,-2*(i-8)+1,2)>
</CFLOOP>
<CFSET hex_msg_len = temp>

<!--- pad the msg to make it a multiple of 512 bits long --->
<CFSET padded_hex_msg = hex_msg & "80" & RepeatString("0",128-((Len(hex_msg)+2+16) Mod 128)) & hex_msg_len>

<!--- initialize MD buffer --->
<CFSET h = ArrayNew(1)>
<CFSET h[1] = InputBaseN("0x67452301",16)>
<CFSET h[2] = InputBaseN("0xefcdab89",16)>
<CFSET h[3] = InputBaseN("0x98badcfe",16)>
<CFSET h[4] = InputBaseN("0x10325476",16)>

<CFSET var = ArrayNew(1)>
<CFSET var[1] = "a">
<CFSET var[2] = "b">
<CFSET var[3] = "c">
<CFSET var[4] = "d">

<CFSET m = ArrayNew(1)>

<CFSET t = ArrayNew(1)>
<CFSET k = ArrayNew(1)>
<CFSET s = ArrayNew(1)>
<CFLOOP index="i" from="1" to="64">
	<CFSET t[i] = Int(2^32*abs(sin(i)))>
	<CFIF i LE 16>
		<CFIF i EQ 1>
			<CFSET k[i] = 0>
		<CFELSE>
			<CFSET k[i] = k[i-1] + 1>
		</CFIF>
		<CFSET s[i] = 5*((i-1) MOD 4) + 7>
	<CFELSEIF i LE 32>
		<CFIF i EQ 17>
			<CFSET k[i] = 1>
		<CFELSE>
			<CFSET k[i] = (k[i-1]+5) MOD 16>
		</CFIF>
		<CFSET s[i] = 0.5*((i-1) MOD 4)*((i-1) MOD 4) + 3.5*((i-1) MOD 4) + 5>
	<CFELSEIF i LE 48>
		<CFIF i EQ 33>
			<CFSET k[i] = 5>
		<CFELSE>
			<CFSET k[i] = (k[i-1]+3) MOD 16>
		</CFIF>
		<CFSET s[i] = 6*((i-1) MOD 4) + ((i-1) MOD 2) + 4>
	<CFELSE>
		<CFIF i EQ 49>
			<CFSET k[i] = 0>
		<CFELSE>
			<CFSET k[i] = (k[i-1]+7) MOD 16>
		</CFIF>
		<CFSET s[i] = 0.5*((i-1) MOD 4)*((i-1) MOD 4) + 3.5*((i-1) MOD 4) + 6>
	</CFIF>
</CFLOOP>

<!--- process the msg 512 bits at a time --->
<CFLOOP index="n" from="1" to="#Evaluate(Len(padded_hex_msg)/128)#">
	
	<CFSET a = h[1]>
	<CFSET b = h[2]>
	<CFSET c = h[3]>
	<CFSET d = h[4]>
	
	<CFSET msg_block = Mid(padded_hex_msg,128*(n-1)+1,128)>
	<CFLOOP index="i" from="1" to="16">
		<CFSET sub_block = "">
		<CFLOOP index="j" from="1" to="4">
			<CFSET sub_block = sub_block & Mid(msg_block,8*i-2*j+1,2)>
		</CFLOOP>
		<CFSET m[i] = InputBaseN(sub_block,16)>
	</CFLOOP>
	
	<CFLOOP index="i" from="1" to="64">
		
		<CFIF i LE 16>
			<CFSET f = BitOr(BitAnd(Evaluate(var[2]),Evaluate(var[3])),BitAnd(BitNot(Evaluate(var[2])),Evaluate(var[4])))>
		<CFELSEIF i LE 32>
			<CFSET f = BitOr(BitAnd(Evaluate(var[2]),Evaluate(var[4])),BitAnd(Evaluate(var[3]),BitNot(Evaluate(var[4]))))>
		<CFELSEIF i LE 48>
			<CFSET f = BitXor(BitXor(Evaluate(var[2]),Evaluate(var[3])),Evaluate(var[4]))>
		<CFELSE>
			<CFSET f = BitXor(Evaluate(var[3]),BitOr(Evaluate(var[2]),BitNot(Evaluate(var[4]))))>
		</CFIF>
		
		<CFSET temp = Evaluate(var[1]) + f + m[k[i]+1] + t[i]>
		<CFLOOP condition="(temp LT -2^31) OR (temp GE 2^31)">
			<CFSET temp = temp - Sgn(temp)*2^32>
		</CFLOOP>
		<CFSET temp = Evaluate(var[2]) + BitOr(BitSHLN(temp,s[i]),BitSHRN(temp,32-s[i]))>
		<CFLOOP condition="(temp LT -2^31) OR (temp GE 2^31)">
			<CFSET temp = temp - Sgn(temp)*2^32>
		</CFLOOP>
		<CFSET temp = SetVariable(var[1],temp)>
		
		<CFSET temp = var[4]>
		<CFSET var[4] = var[3]>
		<CFSET var[3] = var[2]>
		<CFSET var[2] = var[1]>
		<CFSET var[1] = temp>
		
	</CFLOOP>
	
	<CFSET h[1] = h[1] + a>
	<CFSET h[2] = h[2] + b>
	<CFSET h[3] = h[3] + c>
	<CFSET h[4] = h[4] + d>
	
	<CFLOOP index="i" from="1" to="4">
		<CFLOOP condition="(h[i] LT -2^31) OR (h[i] GE 2^31)">
			<CFSET h[i] = h[i] - Sgn(h[i])*2^32>
		</CFLOOP>
	</CFLOOP>
	
</CFLOOP>

<CFLOOP index="i" from="1" to="4">
	<CFSET h[i] = Right(RepeatString("0",7)&UCase(FormatBaseN(h[i],16)),8)>
</CFLOOP>

<CFLOOP index="i" from="1" to="4">
	<CFSET temp = "">
	<CFLOOP index="j" from="1" to="4">
		<CFSET temp = temp & Mid(h[i],-2*(j-4)+1,2)>
	</CFLOOP>
	<CFSET h[i] = temp>
</CFLOOP>

<CFSET caller.msg_digest = h[1] & h[2] & h[3] & h[4]>

</BODY>

</HTML>