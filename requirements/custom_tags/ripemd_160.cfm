<!---
Programmer: Tim McCarthy (tim@timmcc.com)
Date: February, 2003
Description:
	Produces a 160-bit condensed representation of a message (attributes.msg) called
	a message digest (caller.msg_digest) using the RIPEMD-160 hash function as
	specified in http://www.esat.kuleuven.ac.be/~bosselae/ripemd160.html
Required parameter: msg
Optional parameter: format="hex" (hexadecimal, default is ASCII text)
Example syntax: <cf_ripemd_160 msg="abcdefghijklmnopqrstuvwxyz">
Output variable: caller.msg_digest
Note:
	This version accepts input in both ASCII text and hexadecimal formats.
	Previous versions did not accept input in hexadecimal format.
--->

<HTML>
<HEAD>
	<TITLE>RIPEMD-160 Hash Function</TITLE>
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

<!--- define permutations --->
<CFSET rho = ArrayNew(1)>
<CFSET rho[1] = 7>
<CFSET rho[2] = 4>
<CFSET rho[3] = 13>
<CFSET rho[4] = 1>
<CFSET rho[5] = 10>
<CFSET rho[6] = 6>
<CFSET rho[7] = 15>
<CFSET rho[8] = 3>
<CFSET rho[9] = 12>
<CFSET rho[10] = 0>
<CFSET rho[11] = 9>
<CFSET rho[12] = 5>
<CFSET rho[13] = 2>
<CFSET rho[14] = 14>
<CFSET rho[15] = 11>
<CFSET rho[16] = 8>

<CFSET pi = ArrayNew(1)>
<CFLOOP index="i" from="1" to="16">
	<CFSET pi[i] = (9*(i-1)+5) Mod 16>
</CFLOOP>

<!--- define shifts --->
<CFSET shift = ArrayNew(2)>
<CFSET shift[1][1] = 11>
<CFSET shift[1][2] = 14>
<CFSET shift[1][3] = 15>
<CFSET shift[1][4] = 12>
<CFSET shift[1][5] = 5>
<CFSET shift[1][6] = 8>
<CFSET shift[1][7] = 7>
<CFSET shift[1][8] = 9>
<CFSET shift[1][9] = 11>
<CFSET shift[1][10] = 13>
<CFSET shift[1][11] = 14>
<CFSET shift[1][12] = 15>
<CFSET shift[1][13] = 6>
<CFSET shift[1][14] = 7>
<CFSET shift[1][15] = 9>
<CFSET shift[1][16] = 8>
<CFSET shift[2][1] = 12>
<CFSET shift[2][2] = 13>
<CFSET shift[2][3] = 11>
<CFSET shift[2][4] = 15>
<CFSET shift[2][5] = 6>
<CFSET shift[2][6] = 9>
<CFSET shift[2][7] = 9>
<CFSET shift[2][8] = 7>
<CFSET shift[2][9] = 12>
<CFSET shift[2][10] = 15>
<CFSET shift[2][11] = 11>
<CFSET shift[2][12] = 13>
<CFSET shift[2][13] = 7>
<CFSET shift[2][14] = 8>
<CFSET shift[2][15] = 7>
<CFSET shift[2][16] = 7>
<CFSET shift[3][1] = 13>
<CFSET shift[3][2] = 15>
<CFSET shift[3][3] = 14>
<CFSET shift[3][4] = 11>
<CFSET shift[3][5] = 7>
<CFSET shift[3][6] = 7>
<CFSET shift[3][7] = 6>
<CFSET shift[3][8] = 8>
<CFSET shift[3][9] = 13>
<CFSET shift[3][10] = 14>
<CFSET shift[3][11] = 13>
<CFSET shift[3][12] = 12>
<CFSET shift[3][13] = 5>
<CFSET shift[3][14] = 5>
<CFSET shift[3][15] = 6>
<CFSET shift[3][16] = 9>
<CFSET shift[4][1] = 14>
<CFSET shift[4][2] = 11>
<CFSET shift[4][3] = 12>
<CFSET shift[4][4] = 14>
<CFSET shift[4][5] = 8>
<CFSET shift[4][6] = 6>
<CFSET shift[4][7] = 5>
<CFSET shift[4][8] = 5>
<CFSET shift[4][9] = 15>
<CFSET shift[4][10] = 12>
<CFSET shift[4][11] = 15>
<CFSET shift[4][12] = 14>
<CFSET shift[4][13] = 9>
<CFSET shift[4][14] = 9>
<CFSET shift[4][15] = 8>
<CFSET shift[4][16] = 6>
<CFSET shift[5][1] = 15>
<CFSET shift[5][2] = 12>
<CFSET shift[5][3] = 13>
<CFSET shift[5][4] = 13>
<CFSET shift[5][5] = 9>
<CFSET shift[5][6] = 5>
<CFSET shift[5][7] = 8>
<CFSET shift[5][8] = 6>
<CFSET shift[5][9] = 14>
<CFSET shift[5][10] = 11>
<CFSET shift[5][11] = 12>
<CFSET shift[5][12] = 11>
<CFSET shift[5][13] = 8>
<CFSET shift[5][14] = 6>
<CFSET shift[5][15] = 5>
<CFSET shift[5][16] = 5>

<CFSET k1 = ArrayNew(1)>
<CFSET k2 = ArrayNew(1)>
<CFSET r1 = ArrayNew(1)>
<CFSET r2 = ArrayNew(1)>
<CFSET s1 = ArrayNew(1)>
<CFSET s2 = ArrayNew(1)>

<CFLOOP index="i" from="1" to="16">
	
	<!--- define constants --->
	<CFSET k1[i] = 0>
	<CFSET k1[i+16] = Int(2^30*Sqr(2))>
	<CFSET k1[i+32] = Int(2^30*Sqr(3))>
	<CFSET k1[i+48] = Int(2^30*Sqr(5))>
	<CFSET k1[i+64] = Int(2^30*Sqr(7))>
	
	<CFSET k2[i] = Int(2^30*2^(1/3))>
	<CFSET k2[i+16] = Int(2^30*3^(1/3))>
	<CFSET k2[i+32] = Int(2^30*5^(1/3))>
	<CFSET k2[i+48] = Int(2^30*7^(1/3))>
	<CFSET k2[i+64] = 0>
	
	<!--- define word order --->
	<CFSET r1[i] = i-1>
	<CFSET r1[i+16] = rho[i]>
	<CFSET r1[i+32] = rho[rho[i]+1]>
	<CFSET r1[i+48] = rho[rho[rho[i]+1]+1]>
	<CFSET r1[i+64] = rho[rho[rho[rho[i]+1]+1]+1]>
	
	<CFSET r2[i] = pi[i]>
	<CFSET r2[i+16] = rho[pi[i]+1]>
	<CFSET r2[i+32] = rho[rho[pi[i]+1]+1]>
	<CFSET r2[i+48] = rho[rho[rho[pi[i]+1]+1]+1]>
	<CFSET r2[i+64] = rho[rho[rho[rho[pi[i]+1]+1]+1]+1]>
	
	<!--- define rotations --->
	<CFSET s1[i] = shift[1][r1[i]+1]>
	<CFSET s1[i+16] = shift[2][r1[i+16]+1]>
	<CFSET s1[i+32] = shift[3][r1[i+32]+1]>
	<CFSET s1[i+48] = shift[4][r1[i+48]+1]>
	<CFSET s1[i+64] = shift[5][r1[i+64]+1]>
	
	<CFSET s2[i] = shift[1][r2[i]+1]>
	<CFSET s2[i+16] = shift[2][r2[i+16]+1]>
	<CFSET s2[i+32] = shift[3][r2[i+32]+1]>
	<CFSET s2[i+48] = shift[4][r2[i+48]+1]>
	<CFSET s2[i+64] = shift[5][r2[i+64]+1]>
	
</CFLOOP>

<!--- define buffers --->
<CFSET h = ArrayNew(1)>
<CFSET h[1] = InputBaseN("0x67452301",16)>
<CFSET h[2] = InputBaseN("0xefcdab89",16)>
<CFSET h[3] = InputBaseN("0x98badcfe",16)>
<CFSET h[4] = InputBaseN("0x10325476",16)>
<CFSET h[5] = InputBaseN("0xc3d2e1f0",16)>

<CFSET var1 = ArrayNew(1)>
<CFSET var1[1] = "a1">
<CFSET var1[2] = "b1">
<CFSET var1[3] = "c1">
<CFSET var1[4] = "d1">
<CFSET var1[5] = "e1">

<CFSET var2 = ArrayNew(1)>
<CFSET var2[1] = "a2">
<CFSET var2[2] = "b2">
<CFSET var2[3] = "c2">
<CFSET var2[4] = "d2">
<CFSET var2[5] = "e2">

<CFSET x = ArrayNew(1)>

<!--- process msg in 16-word blocks --->
<CFLOOP index="n" from="1" to="#Evaluate(Len(padded_hex_msg)/128)#">
	
	<CFSET a1 = h[1]>
	<CFSET b1 = h[2]>
	<CFSET c1 = h[3]>
	<CFSET d1 = h[4]>
	<CFSET e1 = h[5]>
	
	<CFSET a2 = h[1]>
	<CFSET b2 = h[2]>
	<CFSET c2 = h[3]>
	<CFSET d2 = h[4]>
	<CFSET e2 = h[5]>
	
	<CFSET msg_block = Mid(padded_hex_msg,128*(n-1)+1,128)>
	<CFLOOP index="i" from="1" to="16">
		<CFSET sub_block = "">
		<CFLOOP index="j" from="1" to="4">
			<CFSET sub_block = sub_block & Mid(msg_block,8*i-2*j+1,2)>
		</CFLOOP>
		<CFSET x[i] = InputBaseN(sub_block,16)>
	</CFLOOP>
	
	<CFLOOP index="j" from="1" to="80">
		
		<!--- nonlinear functions --->
		<CFIF j LE 16>
			<CFSET f1 = BitXor(BitXor(Evaluate(var1[2]),Evaluate(var1[3])),Evaluate(var1[4]))>
			<CFSET f2 = BitXor(Evaluate(var2[2]),BitOr(Evaluate(var2[3]),BitNot(Evaluate(var2[4]))))>
		<CFELSEIF j LE 32>
			<CFSET f1 = BitOr(BitAnd(Evaluate(var1[2]),Evaluate(var1[3])),BitAnd(BitNot(Evaluate(var1[2])),Evaluate(var1[4])))>
			<CFSET f2 = BitOr(BitAnd(Evaluate(var2[2]),Evaluate(var2[4])),BitAnd(Evaluate(var2[3]),BitNot(Evaluate(var2[4]))))>
		<CFELSEIF j LE 48>
			<CFSET f1 = BitXor(BitOr(Evaluate(var1[2]),BitNot(Evaluate(var1[3]))),Evaluate(var1[4]))>
			<CFSET f2 = BitXor(BitOr(Evaluate(var2[2]),BitNot(Evaluate(var2[3]))),Evaluate(var2[4]))>
		<CFELSEIF j LE 64>
			<CFSET f1 = BitOr(BitAnd(Evaluate(var1[2]),Evaluate(var1[4])),BitAnd(Evaluate(var1[3]),BitNot(Evaluate(var1[4]))))>
			<CFSET f2 = BitOr(BitAnd(Evaluate(var2[2]),Evaluate(var2[3])),BitAnd(BitNot(Evaluate(var2[2])),Evaluate(var2[4])))>
		<CFELSE>
			<CFSET f1 = BitXor(Evaluate(var1[2]),BitOr(Evaluate(var1[3]),BitNot(Evaluate(var1[4]))))>
			<CFSET f2 = BitXor(BitXor(Evaluate(var2[2]),Evaluate(var2[3])),Evaluate(var2[4]))>
		</CFIF>
		
		<CFSET temp = Evaluate(var1[1]) + f1 + x[r1[j]+1] + k1[j]>
		<CFLOOP condition="(temp LT -2^31) OR (temp GE 2^31)">
			<CFSET temp = temp - Sgn(temp)*2^32>
		</CFLOOP>
		<CFSET temp = BitOr(BitSHLN(temp,s1[j]),BitSHRN(temp,32-s1[j])) + Evaluate(var1[5])>
		<CFLOOP condition="(temp LT -2^31) OR (temp GE 2^31)">
			<CFSET temp = temp - Sgn(temp)*2^32>
		</CFLOOP>
		<CFSET temp = SetVariable(var1[1],temp)>
		<CFSET temp = SetVariable(var1[3],BitOr(BitSHLN(Evaluate(var1[3]),10),BitSHRN(Evaluate(var1[3]),32-10)))>
		
		<CFSET temp = var1[5]>
		<CFSET var1[5] = var1[4]>
		<CFSET var1[4] = var1[3]>
		<CFSET var1[3] = var1[2]>
		<CFSET var1[2] = var1[1]>
		<CFSET var1[1] = temp>
		
		<CFSET temp = Evaluate(var2[1]) + f2 + x[r2[j]+1] + k2[j]>
		<CFLOOP condition="(temp LT -2^31) OR (temp GE 2^31)">
			<CFSET temp = temp - Sgn(temp)*2^32>
		</CFLOOP>
		<CFSET temp = BitOr(BitSHLN(temp,s2[j]),BitSHRN(temp,32-s2[j])) + Evaluate(var2[5])>
		<CFLOOP condition="(temp LT -2^31) OR (temp GE 2^31)">
			<CFSET temp = temp - Sgn(temp)*2^32>
		</CFLOOP>
		<CFSET temp = SetVariable(var2[1],temp)>
		<CFSET temp = SetVariable(var2[3],BitOr(BitSHLN(Evaluate(var2[3]),10),BitSHRN(Evaluate(var2[3]),32-10)))>
		
		<CFSET temp = var2[5]>
		<CFSET var2[5] = var2[4]>
		<CFSET var2[4] = var2[3]>
		<CFSET var2[3] = var2[2]>
		<CFSET var2[2] = var2[1]>
		<CFSET var2[1] = temp>
		
	</CFLOOP>
	
	<CFSET t = h[2] + c1 + d2>
	<CFSET h[2] = h[3] + d1 + e2>
	<CFSET h[3] = h[4] + e1 + a2>
	<CFSET h[4] = h[5] + a1 + b2>
	<CFSET h[5] = h[1] + b1 + c2>
	<CFSET h[1] = t>
	
	<CFLOOP index="i" from="1" to="5">
		<CFLOOP condition="(h[i] LT -2^31) OR (h[i] GE 2^31)">
			<CFSET h[i] = h[i] - Sgn(h[i])*2^32>
		</CFLOOP>
	</CFLOOP>
	
</CFLOOP>

<CFLOOP index="i" from="1" to="5">
	<CFSET h[i] = Right(RepeatString("0",7)&UCase(FormatBaseN(h[i],16)),8)>
</CFLOOP>

<CFLOOP index="i" from="1" to="5">
	<CFSET temp = "">
	<CFLOOP index="j" from="1" to="4">
		<CFSET temp = temp & Mid(h[i],-2*(j-4)+1,2)>
	</CFLOOP>
	<CFSET h[i] = temp>
</CFLOOP>

<CFSET caller.msg_digest = h[1] & h[2] & h[3] & h[4] & h[5]>

</BODY>

</HTML>