<div class="pageContainer">
	<div class="main">
		<h1 class="title">Welcome to my page</h1>
		<section class="section">
			<p>It is really nice to see you here</p>
			<p>
				Here is a link to a small API: <a href="fuzzklang.net/webservice/"
					>fuzzklang.net/webservice/</a
				>
			</p>
		</section>
	</div>
</div>

<style>
	.pageContainer {
		display: flex;
		justify-content: center;
		font-family: 'Courier New', Courier, monospace;
		background-color: rgb(39, 59, 59);
		color: rgb(228, 228, 228);
		width: 100%;
		height: 100vh;
	}

	.main {
		display: flex;
		flex-direction: column;
		width: 960px;
	}

	.main > * {
		align-self: center;
	}

	.title {
		display: flex;
		flex-direction: column;
		padding-top: 3em;
		padding-bottom: 1em;
	}

	.section {
		display: flex;
		flex-direction: column;
		flex-grow: 1;
	}
</style>
