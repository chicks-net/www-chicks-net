+++
title = 'Review of Microservices Pros and Cons'
date = 2025-03-10
draft = false
description = 'Review of Microservices: Pros and Cons article from Ovid'
# cover.image = '/posts/'
cover.hidden = true
tags = ["cloud", "review"]
ShowToc = true
+++

Eventually this blog post is going to work around to being a review of
["Microservices Pros and Cons" by Curtis Poe](https://curtispoe.org/articles/microservices-pros-and-cons.html).
It is going to meander a bit before it gets to the review, but I haven't
found a way to leave out this "preamble".  In some sense it is beside the point,
but in other senses it is the whole point.  YMMV.

## Presumption of bias

I would guess that most innocent bystanders reading a title like "Pros and Cons"
would assume that the author intended to present a balanced view of the topic at hand.
Having been in the computer business for the last thirty years I presume every
author has some ax to grind.

Often someone has a financial incentive to profess their position and when you try
what they say it isn't nearly as rosy as they pretended.  Shocker, right?
Or someone has been burned by a technology and they need to warn everyone else to
avoid it.  This is easier to accept as truthful, but there's a risk that you're
skipping a technology that could work great for you.

So it was with great surprise that I found
[this article by Curtis Poe](https://curtispoe.org/articles/microservices-pros-and-cons.html)
wasn't terribly biased.
Someone has actually written a balanced article on a controversial technical topic.
It is truly unexpected in this business after all of these years.

## Oh, Ovid!i

I didn't know who Curtis Poe was.  That made it easier for me to fall into the presumption of bias.

But it didn't take much research to figure out that Curtis Poe is
[Ovid](https://metacpan.org/author/OVID) from the Perl community!
As you can see there, he has contributed a variety of great code
to the community over a twenty year period.

I had not realized that Curtis also worked at
[the BBC and booking.com](https://www.linkedin.com/in/curtispoe/),
but it is great to see that he has had a long career contributing
to some brands that we have all heard of.
It is also amazing and cool that Curtis served as Director
for [The Perl Foundation](https://www.perlfoundation.org/)
for twelve years.

If I'd known that Curtis Poe was Ovid, I would not have had such low
expectations for their writing.  Sorry for being a curmudgeonly techie,
but happily I think that's enough preamble.

## Review of Microservices Pros and Cons

If you haven't yet, you really should go read
["Microservices Pros and Cons" by Curtis Poe](https://curtispoe.org/articles/microservices-pros-and-cons.html)
now for the rest of this to make much sense.

I was amazed that I found myself agreeing with almost everything that was said
in the article.  Here are some quick points that map to his outline:

- __Opening__
  - He wrecked an interview over microservices.  I've wrecked interviews over logs.  It felt like an odd opening while also feeling familiar.
- __Benefits__
  - Scalability is key.  It is a big conceptual change to accept that you don't just have one process on one machine.
  - "Learning" is all about managing how much information we can keep in our heads at once.  So true.
  - Gradual migration is the easiest way to modernize a complex system, but it may be impractical without institutional knowledge.
  - Data formats are central.  Show me your data structures and I can guess your code.
  - Async is necessary for surviving in the cloud and scaling affordably.  Use async wherever possible.
  - I have seen "New Business Products" evolve out of healthy microservices environments.
  - "Partial Failures" is another way to say graceful degradation.  Expect and plan for failure.
  - The Dark Secret of using weird languages in containers is that it makes them easier to live with.
- __Drawbacks__
  - Infrastructure is needed.  Pick your platform and see how far it will get you.
  - Monitoring is usually forgotten until it is needed.  Hopefully your platform gives it to you for "free".
  - Overhead is absolutely one of the prices we pay for operating in the cloud.

Those were easy to cover because it was all so agreeable and reasonable to what I've experienced.

### Drawback: Data Consistency

The final drawback is "Data Consistency". Here Poe goes into a bit more of a rant by his own admission.
Most of this centers on PostgreSQL installs tending to have better data quality before he arrives
than MySQL-based systems.  I'm not surprised that this has been his experience and that dealing with the
MySQL folks can be frustrating from this angle.

I have worked with MySQL systems that were serious about data consistency and that didn't have dangling
foreign keys or other forms of corruption.  The systems I'm thinking of were built before PostgreSQL
had performance adequate for web apps.  Most of my experience at this level was during my days of
solely being a consultant.

For the last fifteen years, in day job contexts, AWS dominates.  In the cloud, enabling MySQL or PostgreSQL
is like flipping a light switch.  AWS RDS is happy to give you any recent version of either database at a wide
variety of scales and price ranges.  Automatic backups and replication are just a few more clicks.
Many services have their own RDS of whatever flavor and the choice
doesn't have much effect on the operation of the overall system.

Curtis suggests that all of these small databases are problematic for licensing
reasons for folks using Oracle™.
Luckily I haven't run into Oracle since I consulted for government agencies 20+ years ago.
(I've got some old Oracle books, if anyone is interested.)
In the California tech scene Oracle is not considered as an option.
Unless you own stock, I'm not sure what would compel anyone to use Oracle anymore.

Ultimately, while I agree that moving to microservices can exacerbate data problems,
it is also another chance to get it right.  Hopefully it doesn't get punted
until the next refactor or reorg.

### Complexity

I'd summarize this section as saying that "onboarding onto a platform can be painful".
I've had this experience too many times to count, so I'm not going to pretend that this
pain is not real and recurring.

All platforms start this way.  You have a bespoke system assembled with hope, duct tape, and
undocumented config files.  New developers repeatedly undergo multi-day initiations into the
system.  __It doesn't have to end this way.__  Docs can be improved.  Interfaces can get simplified.
Sane defaults can get chosen.

Over time the multi-day initiations may turn into an hour-long call.  Maybe the platform is so cool
that it gets open sourced and keeps getting better for ever more.

But we don't have to live with it.  We can improve the platform we're on or we can choose to move
to a better platform.  These aren't easy things, but you should try it if you can find the time.

## Organizational Structure

Maybe this is just my personal ax to grind, but I felt the main thought that was missing from
Curtis' article was how organization structure often leads to similar software designs.
This idea came to be known as [Conway's law](https://en.wikipedia.org/wiki/Conway%27s_law):

> [O]rganizations which design systems (in the broad sense used here) are
> constrained to produce designs which are copies of the communication structures
> of these organizations.

Microservices make it easier for this to become true for your organization.

A service may become too complex over time.
This service is probably important to the business and will have
more engineers assigned to it over this time.  Eventually this becomes too difficult to manage
at a technical level or organizational level.  Regardless of cause, microservices provides a good
model for dealing with it.  The team may be split into subteams that focus on different parts.
Those parts will soon become their own services and the old "monolith" service can be retired.
Ownership evolves and each subteam is left with a more managable cognitive load.

## Time delay

I asked myself whether there was any value to post this 16 months after the original article.
The question of whether to migrate to microservices seems to be an ongoing concern for many teams.
So highlighting Curtis' excellent advice and adding my own perspective will hopefully help
your team make this major design choice.

## Conclusion

Microservices are an established tool to handle the evolving complexity of your software.
Considering the benefits and challenges is critical to determining whether it is the right
move for your code and team.

If you're on a steady growth curve, microservices are going to be hard to live without eventually.
So it becomes more of a choice of how best to time the pain of a refactor.

There are no easy answers, but hopefully you can now make a better informed choice.

## PostScript™

I am happy and amazed that [Ovid liked my review](https://github.com/chicks-net/www-chicks-net/pull/32#issuecomment-2712859793)!
