# DocPad Configuration File
# http://docpad.org/docs/config

# Define the DocPad Configuration
docpadConfig = {
	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# Specify some site properties
		site:
			# The production url of our website
			url: "http://rohitnair.info"

			# The default title of our website
			title: "Rohit Nair's Blog"

			# The website description (for SEO)
			description: """
				Rohit Nair's personal blog.
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				rohit, rohit nair, nair, rohitnair, tech, programming, web development, trivia, football, food, restaurants, reviews
				"""

			# The website author's name
			author: "Rohit Nair"

			# The website author's email
			email: "your@email.com"

			# Styles
			styles: [
				"/styles/blog.css",
				"/styles/solarized_dark.css"
			]

			# Scripts
			scripts: [
				"/scripts/blog.js"
			]

		# -----------------------------
		# Helper Functions

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
			# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')


	# =================================
	# Collections
	# These are special collections that our website makes available to us

	collections:
		pages: (database) ->
			database.findAllLive({pageOrder: $exists: true}, [pageOrder:1,title:1])

		posts: (database) ->
			database.findAllLive({tags:$has:'post'}, [date:-1])

}

# Export the DocPad Configuration
module.exports = docpadConfig
