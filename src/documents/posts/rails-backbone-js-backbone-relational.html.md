---
author: admin
comments: true
date: 2012-03-29 22:45:10+00:00
layout: post
slug: rails-backbone-js-backbone-relational
title: Rails + Backbone.js + Backbone-relational
wordpress_id: 236
categories:
- Tech
tags: ['post']
---

Playing around with Rails and Backbone.js for the last few weeks has been nothing but fun. Both libraries have features and functionality that almost seem like magic. At the same time, they have their limitations as well. For instance, I've really felt the need for a way to express relations within Backbone. This would enable a one-to-one mapping between Rails and Backbone models and would, in general, make things a lot simpler. The Backbone docs quite clearly mention that they will not be adding direct support for nested models/relations, and one has to look elsewhere for it. Searching around will lead you to the Backbone-relational library, which is a Github project and well maintained. The documentation, however, is a bit lacking and there are no demo/tutorials either (the lack of a tutorial is an open bug against the project) And thus, I decided to build a demo app using Rails, Backbone.js and Backbone-relational.

<!-- more -->

To quickly get started, I used the help of scaffolding and the rails-backbone gem. The rails-backbone gem provides rails like scaffolding to create a basic structure for your backbone app. Although not necessary (and probably overkill for this demo) it is an easy way to get things running quickly, and you also don't need to worry about structuring your code later. (warning: this gem generates Coffeescript, which may or may not be a good thing) For this demo, I have two models, Posts and Comments. Both have a field to hold some text content. The rails associations are defined as follows - a Post "has_many" Comments and a Comment "belongs_to" a Post. By following the instructions on the rails-backbone documentation, you can generate the code for both models, for both rails as well as backbone. (Scaffolding is not something I'd recommend in general, but is quite handy in this case) At this point of time, you could verify things are working fine by hitting [localhost:3000/posts](localhost:3000/posts) .

To use Backbone-relational, first get the JS file from the Github project, plonk it somewhere in the include path (vendor/assets/javascripts might be a good option) and edit your application.js file so that it gets picked up. Next, we edit the models as shown below. The models extend Backbone.RelationalModel instead of Backbone.model, and you also set the relations option within the model. In this case, the Post model has a "HasMany" relation with Comments, and Comments automatically has a relation of type "HasOne" set for Posts. Since a Post can have many comments related to it, they are stored in a CommentsCollection, which is specified by the CollectionType option.

The Backbone Post model and collection are defined as follows
``` coffeescript
class RailsBackboneRelational.Models.Post extends Backbone.RelationalModel
  paramRoot: 'post'

  defaults:
    title: null

  relations: [
    type: Backbone.HasMany
    key: 'comments'
    relatedModel: 'RailsBackboneRelational.Models.Comment'
    collectionType: 'RailsBackboneRelational.Collections.CommentsCollection'
    includeInJSON: false
    reverseRelation:
      key: 'post_id',
      includeInJSON: 'id'
  ]

class RailsBackboneRelational.Collections.PostsCollection extends Backbone.Collection
  model: RailsBackboneRelational.Models.Post
  url: '/posts'

```

The Comment model is defined as follows
``` coffeescript
class RailsBackboneRelational.Models.Comment extends Backbone.RelationalModel
  paramRoot: 'comment'

  defaults:
    content: null

class RailsBackboneRelational.Collections.CommentsCollection extends Backbone.Collection
  model: RailsBackboneRelational.Models.Comment
  url: '/comments'

```

You can now refer to the Comments in a Post using regular Backbone methods, for eg. post.get('comments') will return a CommentsCollection object. This collection is nothing but the set of Comments "related" to that particular post. Similarly, you could do the reverse, and access the parent post from a Comment using something like comment.get('post'). In this case, the reverse relation key is post_id, and you'd have to do comment.get('post_id') instead. This is slightly misleading, as it returns a Post object, and not just the post_id. However, if you call a toJSON() on the comment model, it will include only the id field of the post object (this is specified by the includeInJSON option) Rails only needs a post_id field to create and associate a new comment with an existing post, and so we can ignore the rest of the attributes. In short, make sure the key and includeInJSON options in reverseRelation correspond to what Rails is expecting. Similarly, calling a toJSON() on the Post model will return only the parent Post object, and all nested comments will be ignored because of the 'includeInJSON: false' option. Also, initializing the Posts collection from the Rails view now becomes as easy as changing @posts.to_json.html_safe to @posts.to_json({:include => :comments}).html_safe , and BackboneRelational automatically takes care of the rest by initializing the nested Comment models as well (this is because the createModels option is set to true by default)

The rails-backbone gem also includes a couple of other JS files that are of note, backbone_datalink.js and backbone_rails_sync.js. The first binds change event handlers to all generated views that have forms/input fields, while the second just overrides the default Backbone.Sync function to make it work seamlessly with Rails.

You can see this demo live at [http://rails-backbone-relational.herokuapp.com/posts](http://rails-backbone-relational.herokuapp.com/posts) and the code at [https://github.com/rohitnair/rails-backbone-relational](https://github.com/rohitnair/rails-backbone-relational) You can create, edit and delete posts. You can also create and delete comments related to each post. A majority of my modifications to the scaffold generated code are on the view and template files. The post model also uses the above mentioned backbone_datalink lib to grab updated values from the form, while the comment model simply grabs the value in the input box using a jQuery .val() call. 

Resources/Docs:
[Backbone.js documentation](http://documentcloud.github.com/backbone/)
Example Backbone.js [Todo application](http://documentcloud.github.com/backbone/examples/todos/index.html) with [annotated source](http://documentcloud.github.com/backbone/docs/todos.html)
[rails-backbone gem](https://github.com/codebrew/backbone-rails) (github)
[Backbone-relational](https://github.com/PaulUithol/Backbone-relational) (github)
