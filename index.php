<!DOCTYPE html>
<html>
	<head>
		<title>Board Development</title>
		<meta charset = "utf-8" />
		<link type = "text/css" rel = "stylesheet" href = "style.css" />
	</head>
	<body>
	
		<!-- Construct main section of page -->
		<div id = "main">
			<div id = "banner"></div>
			<?php
				echo(exec("lua board.lua")); // Import all information and display threads
			?>
		</div>
		
		<!-- Include on-the-fly interface simplification if JavaScript is enabled -->
		<script src = "interface.js"></script>
		
	</body>
</html>