@api
Feature: Views
  In order to present and expose content and configuration
  As a site owner
  I want to have views for various contexts and applications.

  Scenario: Views
    Then exactly the following views should exist
      | Name                 | Machine name       | Base table        | Status   | Description                                                                                   |
      | Archive              | archive            | Content           | Disabled | All content, by month.                                                                        |
      | Contact messages     | contact_messages   | Contact message   | Enabled  | View and manage messages sent through contact forms.                                          |
      | Content              | content            | Content           | Enabled  | Find and manage content.                                                                      |
      | Custom block library | block_content      | Custom block      | Enabled  | Find and manage custom blocks.                                                                |
      | Files                | files              | Files             | Enabled  | Find and manage files.                                                                        |
      | Frontpage            | frontpage          | Content           | Enabled  | All content promoted to frontpage                                                             |
      | Glossary             | glossary           | Content           | Disabled | All content, by letter.                                                                       |
      | Media                | media              | Media             | Enabled  |                                                                                               |
      | Moderated content    | moderated_content  | Content revisions | Enabled  | Find and moderate content.                                                                    |
      | Moderation history   | moderation_history | Content revisions | Enabled  |                                                                                               |
      | People               | user_admin_people  | Users             | Enabled  | Find and manage people interacting with your site.                                            |
      | Recent content       | content_recent     | Content           | Enabled  | Recent content.                                                                               |
      | Search               | search             | Index Content     | Enabled  |                                                                                               |
      | Taxonomy term        | taxonomy_term      | Content           | Enabled  | Content belonging to a certain taxonomy term.                                                 |
      | Watchdog             | watchdog           | Log entries       | Enabled  | Recent log messages                                                                           |
      | Who's new            | who_s_new          | Users             | Enabled  | Shows a list of the newest user accounts on the site.                                         |
      | Who's online block   | who_s_online       | Users             | Enabled  | Shows the user names of the most recently active users, and the total number of active users. |
