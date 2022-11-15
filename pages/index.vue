<template>
  <div class="root">
    <div class="poster-container">
      <div
        v-loading="isDownloading"
        class="poster-control"
        element-loading-text="Loading ..."
        element-loading-background="rgba(0, 0, 0, 0.8)"
      >
        <h1>Event Poster Generator（Version {{ getVersion }}）</h1>
        <el-form>
          <el-tabs>
            <el-tab-pane label="Event Details">
              <el-form-item label="Event Times">
                <el-input v-model="eventTimes" autosize type="textarea" />
              </el-form-item>
              <el-form-item
                label="Image Upload">
                <el-upload
                  action="#"
                  :show-file-list="false"
                  :on-change="updateFeatureImage"
                  :auto-upload="false"
                  accept="image/*" >
                  <img
                    v-if="featureImageUrl"
                    :src="featureImageUrl"
                    class="member-avatar-uploader"
                  />
                  <i v-else class="el-icon-plus member-avatar-uploader"></i>
                </el-upload>
              </el-form-item>
              <el-form-item label="QR-Code & Link">
                <el-input v-model="qr" />
              </el-form-item>
            </el-tab-pane>

            <el-form-item>
              <el-button type="primary" @click="download()">
                Download Image
              </el-button>
            </el-form-item>
          </el-tabs>
        </el-form>
      </div>
      <div id="poster-preview">
        <div class="top">
          <div class="image">
            <img
              v-if="featureImageUrl"
              class="picture"
              :src="featureImageUrl"
            />
          </div>
          <div class="details">
            <div class="event-times" v-html="getEventTimesMd"></div>
          </div>
        </div>
      </div> <!-- /poster-preview -->
    </div>
    <div class="copy-right">
      <small>
        <a href="http://github.com/AmmanVMS/event-poster-generator">View the source code.</a>
        <i class="el-icon-service"></i> 本工具由
        <a href="http://github.com/Ovilia">@Ovilia</a> 开发，
        <a href="http://github.com/dz85">@David Z.</a> 重构/修改，
        <a href="http://github.com/mythcsj">@mythcsj</a> 优化，
        <a href="mailto:geek@lzw.name">问题反馈</a>,
        <a href="http://github.com/niccokunzmann">@niccokunzmann</a>
      </small>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import AsyncComputed from 'vue-async-computed'
import domtoimage from 'retina-dom-to-image'
import qrcode from 'qrcode'
import MarkdownIt from 'markdown-it'

import { ElUploadInternalFileDetail } from 'element-ui/types/upload'
import v from '../version.json'

const URL = window.URL || window.webkitURL

Vue.use(AsyncComputed)

export default Vue.extend({
  data() {
    return {
      eventTimes: "",
      featureImageUrl: "",
      eventDescription: `## heading
- list
- of
- something

`,
      qr: 'https://ammanvalley.foss.wales/',

      track: 'track',
      imageUrl: null as unknown as string,
      isDownloading: false,
      posterBase64: '',
    }
  },

  computed: {
    getVersion(): string {
      return v.version
    },

    getEventTimesMd(): string {
      const md = new MarkdownIt()
      return md.render(this.eventTimes)
    },

  },

  asyncComputed: {
    async getQr(): Promise<string> {
      if (this.qr === '') return ''

      const dataURL = await qrcode.toDataURL(this.qr)
      return dataURL
    },
  },

  mounted() {},

  methods: {
    updateFeatureImage(file: ElUploadInternalFileDetail) {
      if (!file) return

      if (this.featureImageUrl !== '') URL.revokeObjectURL(this.featureImageUrl)

      this.featureImageUrl = URL.createObjectURL(file.raw)
    },

    async download() {

      if(!this.featureImageUrl){
        alert('请上传头像');
        return;
      }

      if(this.memberName == '姓名'){
        alert('请填写姓名');
        return;
      }

      this.isDownloading = true
      const url = await domtoimage.toJpeg(
        document.getElementById('poster-preview')
      )

      const downloadLink = document.createElement('a')
      downloadLink.href = url
      /**
       * chromium bug:
       *    detail: https://bugs.chromium.org/p/chromium/issues/detail?id=375634
       *    status: WontFix
       *    相关： https://html.spec.whatwg.org/multipage/links.html#downloading-resources
       */
      downloadLink.download = `${this.memberName}.jpg`
      downloadLink.click()
      this.isDownloading = false
    },
  },
})
</script>

<style lang="scss">
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: bold;
  src: url(~assets/OpenSans-Bold.ttf) format('truetype');
}
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: normal;
  src: url(~assets/OpenSans-Light.ttf) format('truetype');
}
@font-face {
  font-family: 'SourceHanSerifSC';
  font-style: normal;
  font-weight: bold;
  src: url(~assets/SourceHanSerifSC-Heavy.otf) format('opentype');
}

h1 {
  display: block;
  margin-block-start: 0.3em;
  margin-block-end: 0.3em;
  margin-inline-start: 0px;
  margin-inline-end: 0px;
  font-size: 1.8em;
  font-weight: bold;
}

h2 {
  display: block;
  margin-block-start: 0.25em;
  margin-block-end: 0.25em;
  margin-inline-start: 0px;
  margin-inline-end: 0px;
  font-size: 1.5em;
  font-weight: normal;
}

small {
  display: block;
  margin-block-start: 0.1em;
  margin-block-end: 0.1em;
  margin-inline-start: 0px;
  margin-inline-end: 0px;
  font-size: 0.6em;
  font-weight: bold;
}

p {
  display: block;
  margin-block-start: 0em;
  margin-block-end: 1.5em;
  margin-inline-start: 0px;
  margin-inline-end: 0px;
  font-size: 0.8em;
}

@mixin justify {
  text-align: justify;
  text-align-last: justify;
  text-justify: inter-ideograph;
}

.root {
  min-width: 600px;
  display: flex;
  flex-direction: column;
  align-items: center;

  .poster-container {
    font-family: 'Open Sans';
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    // flex-wrap: wrap;

    .poster-control {
      min-width: 600px;
      .el-upload {
        display: flex;
        justify-content: center;
        align-items: center;
        border: 1px dashed #888;
        border-radius: 6px;
        .member-avatar-uploader {
          width: 32px;
          height: 32px;
          display: flex;
          justify-content: center;
          align-items: center;
          cursor: pointer;
          &:hover {
            border-color: #409eff;
          }
        }
      }
    }

    #poster-preview {
      width: 21cm;
      height: 29.7cm;
      padding: 10mm 10mm 10mm 10mm;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      align-items: stretch;
      background-color: white;
      box-sizing: border-box;

      .header,
      .footer {
        font-size: 1em;
        height: 15%;
        display: flex;
      }

      .header {
        font-size: 1em;
        justify-content: space-between;
        align-items: stretch;
        border-bottom: 1px dashed black;

        .forum-banner {
          font-size: 1em;
          width: 55%;
          display: flex;
          flex-direction: column;
          justify-content: flex-start;
          align-items: stretch;

          .forum-name,
          .forum-slogon,
          .forum-detail {
            margin-block-start: 0em;
            margin-block-end: 0em;
          }

          .forum-name {
            @include justify();
          }

          .forum-slogon {
            background: #266481;
            color: #ffc600;
            text-transform: uppercase;
            font-weight: bold;
          }

          .forum-detail {
            @include justify();
          }
        }

        .logo {
          font-size: 1em;
          width: 25%;
          background: url(~assets/logo.png) top no-repeat;
          background-size: contain;
        }
      }
      .footer {
        font-size: 1em;
        border-top: 1px dashed black;
        flex-direction: column;
        justify-content: flex-end;
        align-items: center;

        img {
          font-size: 1em;
          width: 20%;
          height: auto;
        }
      }
      .content {
        font-size: 1em;
        height: 60%;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        text-align: center;

        .member-avatar-mask,
        .member-avatar {
          font-size: 1em;
          width: 150px;
          height: 150px;
          // max-width: 128px;
          border: 0.3em solid #151617;
          border-radius: 50%;
          background: #B6E0B9;
          object-fit: cover;

          // &:after {
          //   font-size: 1em;
          //   content: '';
          //   display: block;
          //   padding-top: 100%;
          // }
        }

        .topic-slogon {
          width: 100%;
          color: white;
          background: black;
        }

        .topic-detail {
          font-size: 1em;
          width: 100%;
          text-align: left;
        }
      }
    }
  }

  .copy-right {
    border-top: 1px dashed gray;
    margin: 10px 0;
    text-align: center;

    color: #aaa;
    a {
      color: #aaa;
    }
  }
}

// @media screen and (min-width: 600px) {
//   .root {
//     .poster-container {
//       flex-direction: row;
//       align-items: stretch;
//     }
//   }
// }
</style>
