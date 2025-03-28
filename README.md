![hitobito logo](https://user-images.githubusercontent.com/9592347/184715060-351453d4-d066-4ff6-8f82-95d3b524b62f.svg)

# Welcome to Hitobito 人人

Hitobito is an open source web application to manage organisation and communities with complex group hierarchies with members, events, courses, mailings, communication and a lot more.

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/hitobito/hitobito/graphs/commit-activity)
[![Documentation Status](https://readthedocs.org/projects/hitobito/badge/?version=latest)](https://hitobito.readthedocs.io/?badge=latest)
[![GitHub](https://img.shields.io/github/license/hitobito/hitobito)](https://github.com/hitobito/hitobito/blob/master/LICENSE)
[![Open Source Helpers](https://www.codetriage.com/hitobito/hitobito/badges/users.svg)](https://www.codetriage.com/hitobito/hitobito)
[![Rails Lint and Test](https://github.com/hitobito/hitobito/actions/workflows/tests.yml/badge.svg)](https://github.com/hitobito/hitobito/actions/workflows/tests.yml)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/8947/badge)](https://www.bestpractices.dev/projects/8947)

## User Guide

A generic [user guide in German](https://hitobito.readthedocs.io/de/latest/) is available.

## Development

Check out our [development kit](https://github.com/hitobito/development/)

More detailed development documentation can be found in [doc/developer](doc/developer).

This is where you also find some [Deployment Instructions](doc/operator/01_deployment.md).

More information about [interfaces, api, oauth and oidc](doc/developer/README.md#interfaces) is also avaible.

## Architecture

The architecture documentation in German can be found in [doc/architecture](doc/developer/modules/common/architecture).

Two topics shall be mentioned here explicitly:

### Group Hierarchy

Hitobito provides a powerful meta-model to describe group structures.
Groups are always of a specific type and are arranged in a tree.
Each group type may have several different role types.

This core part of Hitobito does not provide any specific group or role types.
They have to be defined in a separate plugin, specific to your organization structure.

An example group type definition might look like this:

    class Group::Layer < Group
      self.layer = true

      children Group::Layer, Group::Board, Group::Basic

      class Role < Leader
        self.permissions = [:layer_full, :contact_data]
      end


      class Member < Role
        self.permissions = [:group_read]
      end

      roles Leader, Member
    end

A group type always inherits from the class `Group`.
It may be a layer, which defines a set of groups that are in a common permission range.
All subgroups of a layer group belong to this range unless a subgroup is a layer itself.

Then all possible child types of the group are listed.
When creating subgroups, only these types will be allowed.
As shown, types may be organized recursively.

For the ease of maintainability, role types may be defined directly in the group type.
Each role type has a set of permissions.
They are general indications of what and where.
All specific abilities of a user are derived from the role permissions she has in her different groups.

See [Gruppen- und Rollentypen](doc/developer/modules/common/architecture/08_konzepte.md) for more details and
[hitobito_generic](https://github.com/hitobito/hitobito_generic) for a complete example group
structure.


### Plugin architecture

Hitobito is built on the plugin framework [Wagons](http://github.com/codez/wagons).
With Wagons, arbitrary features and extensions may be created for Hitobito.
As mentioned above, as there are no group types coming from Hitobito itself,
at least one wagon is required to define group types in order to use Hitobito.

See [Wagon Guidelines](doc/developer/modules/common/wagons/README) or [Wagons](http://github.com/codez/wagons)
for more information on wagons and its available rake tasks.

## Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.
Before opening any pull request or issue, please search for existing [issues](https://github.com/hitobito/hitobito/issues) (open and closed) and read the [contributing guidelines](CONTRIBUTING.md). If you are part of an organisation that uses Hitobito, please discuss your intent with the responsible person of your organisation.

## Community

Hitobito made with 💙 and the incredible community:

* Jungwacht Blauring Schweiz
* [Puzzle ITC GmbH](https://www.puzzle.ch)
* Pfadibewegung Schweiz
* Hitobito AG
* CEVI Regionalverband ZH-SH-GL / CEVI Schweiz
* Pro Natura Jugend
* Dachverband Schweizer Jugendparlamente DSJ
* Insieme Schweiz
* Forschungstelle Digitale Nachhaltigkeit
* CH Open
* Digital Impact Network
* Schweizer Blasmusikverband
* Grünliberale Partei Schweiz
* Die Mitte
* Stiftung für junge Auslandschweizer
* Swiss Canoe
* Schweizerischer Sportverband öffentlicher Verkehr (SVSE)
* Schweizer Wanderwege

Please contact [Hitobito](https://hitobito.com) if you want to be part of our community.

## License

Hitobito is released under the [GNU Affero General Public License](LICENSE).

The Hitobito logo is a registered trademark of Hitobito LTD, Switzerland.

---

btw: Hitobito 人人 [means](https://www.wordsense.eu/%E4%BA%BA%E4%BA%BA/) "everyone"
