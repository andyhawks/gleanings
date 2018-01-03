@api
Feature: Content model
  In order to enter structured content into my site
  As a content editor
  I want to have content entity types that reflect my content model.

  Scenario: Bundles
    Then exactly the following entity type bundles should exist
      | type              | label                 | machine name  | moderated | description                                                                   |
      | Contact form      | Contact Form          | sitewide      |           |                                                                               |
      | Contact form      | Personal contact form | personal      |           |                                                                               |
      | Content type      | Basic page            | page          |           | Use <em>basic pages</em> for your static content, such as an 'About us' page. |
      | Content type      | Landing page          | landing_page  |           | A special page with its own one-off layout and content.                       |
      | Crop type         | Freeform              | freeform      |           |                                                                               |
      | Custom block type | Basic block           | basic         |           | A basic block contains a title and a body.                                    |
      | Media type        | Document              | document      |           | A locally hosted document, such a PDF.                                        |
      | Media type        | Image                 | image         |           | Locally hosted images.                                                        |
      | Media type        | Instagram             | instagram     |           | Instagram posts.                                                              |
      | Media type        | Tweet                 | tweet         |           | Represents a tweet.                                                           |
      | Media type        | Video                 | video         |           | A video hosted by YouTube, Vimeo, or some other provider.                     |
      | Shortcut set      | Default               | default       |           |                                                                               |
      | Token type        | Access Token          | access_token  |           | The access token type.                                                        |
      | Token type        | Auth code             | auth_code     |           | The auth code type.                                                           |
      | Token type        | Refresh token         | refresh_token |           | The refresh token type.                                                       |

  Scenario: Fields
    Then exactly the following fields should exist
      | entity type       | bundle       | label                    | machine name                  | type              | required | translatable | cardinality | widget                      | description                                                          |
      | Content type      | Basic page   | Body                     | body                          | text_with_summary |          | translatable | 1           | text_textarea_with_summary  |                                                                      |
      | Content type      | Basic page   | Meta tags                | field_meta_tags               | metatag           |          |              | 1           | metatag_firehose            |                                                                      |
      | Content type      | Basic page   | Panelizer                | panelizer                     | panelizer         |          | translatable | unlimited   | hidden                      |                                                                      |
      | Content type      | Landing page | Description              | body                          | text_with_summary |          | translatable | 1           | text_textarea_with_summary  | A description of this page, for use in teasers and lists of content. |
      | Content type      | Landing page | Meta tags                | field_meta_tags               | metatag           |          | translatable | 1           | metatag_firehose            |                                                                      |
      | Content type      | Landing page | Panelizer                | panelizer                     | panelizer         |          | translatable | unlimited   | panelizer                   |                                                                      |
      | Custom block type | Basic block  | Body                     | body                          | text_with_summary |          | translatable | 1           | text_textarea_with_summary  |                                                                      |
      | Media type        | Document     | Document                 | field_document                | file              |          |              | 1           | file_generic                |                                                                      |
      | Media type        | Document     | Save to my media library | field_media_in_library        | boolean           |          | translatable | 1           | boolean_checkbox            |                                                                      |
      | Media type        | Image        | Image                    | image                         | image             | required |              | 1           | image_widget_crop           |                                                                      |
      | Media type        | Image        | Save to my media library | field_media_in_library        | boolean           |          |              | 1           | boolean_checkbox            |                                                                      |
      | Media type        | Instagram    | Instagram post           | embed_code                    | string_long       | required |              | 1           | string_textarea             | Paste media post URL or embed code.                                  |
      | Media type        | Instagram    | Save to my media library | field_media_in_library        | boolean           |          |              | 1           | boolean_checkbox            |                                                                      |
      | Media type        | Tweet        | Save to my media library | field_media_in_library        | boolean           |          |              | 1           | boolean_checkbox            |                                                                      |
      | Media type        | Tweet        | Tweet                    | embed_code                    | string_long       | required |              | 1           | string_textarea             | Paste tweet's URL or embed code.                                     |
      | Media type        | Video        | Save to my media library | field_media_in_library        | boolean           |          | translatable | 1           | boolean_checkbox            |                                                                      |
      | Media type        | Video        | Video URL                | field_media_video_embed_field | video_embed_field | required | translatable | 1           | video_embed_field_textfield |                                                                      |
