<!--
	To add mobile-specific content fields to your Edit Content screen:
	1) Uncomment the extension type='base' node below with the 'Mobile Options' in it
	2) Reload Application
	3) That's it!
-->
<theme>
	<extensions>
		<!--
		<extension type="Base" subType="Default">
			<attributeset name="Mobile Options" container="Basic">
				<attribute 
					name="hasMobileBody"
					label="Has Mobile Content?"
					hint="If you have mobile-specific content, select Yes."
					type="RadioGroup"
					defaultValue="false"
					required="false"
					validation=""
					regex=""
					message=""
					optionList="true^false"
					optionLabelList="Yes^No" />
				<attribute 
					name="mobileBody"
					label="Mobile Content"
					hint="Enter any mobile-specific content here."
					type="HTMLEditor"
					defaultValue=""
					required="false"
					validation=""
					regex=""
					message=""
					optionList=""
					optionLabelList="" />
			</attributeset>
		</extension>
		-->
		<extension type="Site">
			<attributeset name="MuraBootstrap Theme Options" container="Default">
				<attribute 
					name="mbUseFluid"
					label="Use Fluid Layout?"
					hint="Think in terms of your ENTIRE page...'fluid' would continue expanding the width of your content when your browser is greater than 960px wide and always stretch to fit your browser window, no matter how wide it gets."
					type="RadioGroup"
					defaultValue="false"
					required="false"
					validation=""
					regex=""
					message=""
					optionList="true^false"
					optionLabelList="Yes^No" />
			</attributeset>
		</extension>
	</extensions>
</theme>