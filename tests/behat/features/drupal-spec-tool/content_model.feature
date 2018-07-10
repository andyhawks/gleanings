@api
Feature: Content model
  In order to enter structured content into my site
  As a content editor
  I want to have content entity types that reflect my content model.

  Scenario: Bundles
    Then exactly the following content entity type bundles should exist
      | Name         | Machine name | Type              | Description                                                                   |
      | Basic block  | basic        | Custom block type | A basic block contains a title and a body.                                    |
      | Basic page   | page         | Content type      | Use <em>basic pages</em> for your static content, such as an 'About us' page. |
      | Document     | document     | Media type        | A locally hosted document, such as a PDF.                                     |
      | Image        | image        | Media type        | Locally hosted images.                                                        |
      | Instagram    | instagram    | Media type        | Instagram posts.                                                              |
      | Landing page | landing_page | Content type      | A special page with its own one-off layout and content.                       |
      | Tweet        | tweet        | Media type        | Represents a tweet.                                                           |
      | Video        | video        | Media type        | A video hosted by YouTube, Vimeo, or some other provider.                     |

  Scenario: Fields
    Then exactly the following fields should exist
      | Type              | Bundle       | Field label              | Machine name                  | Field type                           | Required | Cardinality | Form widget               | Translatable | Help text                                                            |
      | Custom block type | Basic block  | Body                     | body                          | Text (formatted, long, with summary) |          | 1           | Text area with a summary  | Translatable |                                                                      |
      | Content type      | Basic page   | Body                     | body                          | Text (formatted, long, with summary) |          | 1           | Text area with a summary  | Translatable |                                                                      |
      | Content type      | Basic page   | Meta tags                | field_meta_tags               | Meta tags                            |          | 1           | Advanced meta tags form   |              |                                                                      |
      | Content type      | Basic page   | Panelizer                | panelizer                     | Panelizer                            |          | Unlimited   | -- Disabled --            | Translatable |                                                                      |
      | Media type        | Document     | Document                 | field_document                | File                                 |          | 1           | File                      |              |                                                                      |
      | Media type        | Document     | Save to my media library | field_media_in_library        | Boolean                              |          | 1           | Single on/off checkbox    | Translatable |                                                                      |
      | Media type        | Image        | Image                    | image                         | Image                                | Required | 1           | ImageWidget crop          |              |                                                                      |
      | Media type        | Image        | Save to my media library | field_media_in_library        | Boolean                              |          | 1           | Single on/off checkbox    |              |                                                                      |
      | Media type        | Instagram    | Instagram post           | embed_code                    | Text (plain, long)                   | Required | 1           | Text area (multiple rows) |              | Paste media post URL or embed code.                                  |
      | Media type        | Instagram    | Save to my media library | field_media_in_library        | Boolean                              |          | 1           | Single on/off checkbox    |              |                                                                      |
      | Content type      | Landing page | Description              | body                          | Text (formatted, long, with summary) |          | 1           | Text area with a summary  | Translatable | A description of this page, for use in teasers and lists of content. |
      | Content type      | Landing page | Meta tags                | field_meta_tags               | Meta tags                            |          | 1           | Advanced meta tags form   | Translatable |                                                                      |
      | Content type      | Landing page | Panelizer                | panelizer                     | Panelizer                            |          | Unlimited   | Panelizer                 | Translatable |                                                                      |
      | Media type        | Tweet        | Tweet                    | embed_code                    | Text (plain, long)                   | Required | 1           | Text area (multiple rows) |              | Paste tweet's URL or embed code.                                     |
      | Media type        | Tweet        | Save to my media library | field_media_in_library        | Boolean                              |          | 1           | Single on/off checkbox    |              |                                                                      |
      | Media type        | Video        | Save to my media library | field_media_in_library        | Boolean                              |          | 1           | Single on/off checkbox    | Translatable |                                                                      |
      | Media type        | Video        | Video URL                | field_media_video_embed_field | Video Embed                          | Required | 1           | Video Textfield           | Translatable |                                                                      |