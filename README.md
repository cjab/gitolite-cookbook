Gitolite Cookbook
=================

Installs Gitolite and configures users and repos.

Requirements
------------

#### Platform
 * Ubuntu

This has only has been tested on Ubuntu 12.10

Attributes
----------

#### gitolite::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['gitolite']['user']</tt></td>
    <td>String</td>
    <td>The user under which gitolite will be run</td>
    <td><tt>git</tt></td>
  </tr>
  <tr>
    <td><tt>['gitolite']['directory']</tt></td>
    <td>String</td>
    <td>The root directory in which gitolite data will be located</td>
    <td><tt>/home/git</tt></td>
  </tr>
</table>

Usage
-----
#### gitolite::default
Just include the `gitolite` recipe in your node's `run_list`


#### gitolite::repos
Include the `gitolite::repos` recipe in your node's `run_list`.

##### Users
The users are assumed to be stored in a data bag named `users`. This example
would be stored in `data_bags/users/username.json`:

    {
      "id":      "username",
      "pub_key": "ssh-rsa AAAA...=="
    }

##### Repos
The repo configuration is stored in a data bag named `gitolite`. This example
would be stored in `data_bags/gitolite/some-git-repo.json`:

    {
      "id":   "some-git-repo",
      "permissions": {
        "RW+": [ "username" ]
      }
    }

The permissions hash mirrors Gitolite's config format: <http://gitolite.com/gitolite/rules.html#permsum>


Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Chad Jablonski (<chad@dinocore.net>)

Copyright: 2013, Chad Jablonski

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
