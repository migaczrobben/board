<!DOCTYPE html>
<html>
	<head>
		<title>Board Development</title>
		<meta charset = "utf-8" />
		<link type = "text/css" rel = "stylesheet" href = "style.css" />
	</head>
	<body>
		<div id = "main">
			<?php
				echo(exec("lua board.lua"));
			?>
		</div>
	</body>
</html>