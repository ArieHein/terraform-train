# TF5

## Overview

This chapter is about scaling the example we have seen in chapter 4. There will be less code but more structure and architecture discussion.

In the directory structure, we have two main folders - **enterprise** and **projects**.

The **enterprise** folder can sit in a repository managed by a central team. This team will be responsible for creating modules, stacks, landing zones, the main building blocks consumed by other projects.

The **projects** folder can sit in a second repository managed by the project team, or even be split into separate ones. The projects will consume the stacks, modules and landing zones created at the enterprise level. The main reason this is possible is due to the fact that a module **source** can point to a URL as well.

For a reminder about the possible values for a module source, view: <https://developer.hashicorp.com/terraform/language/modules/sources#generic-git-repository>

Thus, allowing scenarios where we split between a project repository and the modules / stacks that it consumes. This is exactly similar to when you use a 3rd party library like NPM or NuGet that is referenced in your own application. This split creates an ecosystem that allows governance and control (in terms of cost), security and the knowledge requirement from developers, promoting self-service and autonomy to some degree.

Same as in the library example above, when creating this workflow, we want to maintain proper versioning. Since the URL we use for the source points to the git repository, it is also possible to point to a branch, tag and commit. This allows different projects to point to the same module / stack but to different versions, thus enabling the central team to continually update the module / stack and the project team to decide when to consume the latest version.

At this level of abstraction, it's imperative to have very good communication and training from the main central team to the rest of the projects and their developers. This is a good opportunity to create a centralized UI website that describes all the different stacks and modules provided with their usage, version and any added documentation. It allows clear documentation and transparency to the consumers and also allows them to suggest additional types of stacks or modules thus promoting some of the core principles of DevOps.

There are a few tools in the market allowing you to support this type of self-service workflow, that can even be extended beyond just infrastructure provisioning but they are out of the scope of this short tutorials.
