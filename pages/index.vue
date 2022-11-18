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
            <el-tab-pane label="Event Outline">
              <el-form-item label="Event Title">
                <el-input v-model="eventTitle" autosize type="text" />
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
                    class="feature-image-uploader"
                  />
                  <i v-else class="el-icon-plus feature-image-uploader"></i>
                </el-upload>
              </el-form-item>
              <el-form-item label="Event Description (Markdown)">
                <el-input v-model="eventDescription" autosize type="textarea" />
              </el-form-item>
            </el-tab-pane>
            <el-tab-pane label="Event Details">
              <el-form-item label="Event Times (Markdown)">
                <el-input v-model="eventTimes" autosize type="textarea" />
              </el-form-item>
              <el-form-item label="Event Costs - fixed prize, donation (Markdown)">
                <el-input v-model="eventCost" autosize type="textarea" />
              </el-form-item>
            </el-tab-pane>
            <el-tab-pane label="Contact and Location">
              <el-form-item label="Event Contact Information (Markdown)">
                <el-input v-model="eventContact" autosize type="textarea" />
              </el-form-item>
              <el-form-item label="QR-Code & Link">
                <el-input v-model="qr" />
              </el-form-item>
              <el-form-item label="Event Location (Markdown)">
                <el-input v-model="eventLocation" autosize type="textarea" />
              </el-form-item>
            </el-tab-pane>

            <el-form-item>
              <el-button type="primary" @click="downloadImage()">
                Download Image
              </el-button>
              <el-button type="primary" @click="downloadPDF()">
                Download PDF (print)
              </el-button>
            </el-form-item>
          </el-tabs>
        </el-form>
      </div>
      <div id="poster-preview">
        <div class="left">
          <div class="feature-image"
            v-bind:style="{ backgroundImage: 'url(' + featureImageUrl + ')'}">
            <span class="upload" v-if="!featureImageUrl">⇧</span>
          </div>
          <div class="event-description">
            <h1>{{ eventTitle }}</h1>
            <div class="description" v-html="getEventDescriptionMd"></div>
          </div>
        </div>
        <div class="right">
<!--          <div class="logos"> -->
            <div class="logo" id="ammanvms"></div>
            <div class="logo" id="council"></div>
            <div class="logo" id="qr-code" v-show="qr" v-bind:style="{ backgroundImage: 'url(' + getQr + ')'}"></div>
<!--          </div>
          <div class="details"> -->
            <div class="detail event-location" v-html="getEventLocationMd"></div>
            <div class="detail event-contact" v-html="getEventContactMd"></div>
            <div class="detail event-times" v-html="getEventTimesMd"></div>
            <div class="detail event-cost" v-html="getEventCostMd"></div>
        <!--  </div> -->
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
import moment from 'moment'
import { jsPDF } from "jspdf";

import { ElUploadInternalFileDetail } from 'element-ui/types/upload'
import v from '../version.json'

const URL = window.URL || window.webkitURL

Vue.use(AsyncComputed)

const inTheFuture = new Date();
inTheFuture.setDate(inTheFuture.getDate() + 14);

export default Vue.extend({
  data() {
    return {
      eventTitle: "MakerSpace Event",
      eventLocation: `Amman Valley  
MakerSpace,  
Glanaman,  
Station Road,  
SA18 1LQ`,
      eventTimes: moment().add(14, 'days').format('Do MMM YY, h:00 a'),
      eventCost: `Cost: Pay what you  
can to support us.`,
      eventContact: `My Name

ammanvms@outlook.com

+44 phone number`,
      featureImageUrl: "",
      eventDescription: `First: the purpose of the event and what happens

who it is for (target audience)

which skills/material to bring

which skills to learn

Please bring:
- this
- and that`,
      qr: 'https://ammanvalley.foss.wales/',

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
    getEventContactMd(): string {
      const md = new MarkdownIt()
      return md.render(this.eventContact)
    },
    getEventCostMd(): string {
      const md = new MarkdownIt()
      return md.render(this.eventCost)
    },

    getEventLocationMd(): string {
      const md = new MarkdownIt()
      return md.render(this.eventLocation)
    },
    getEventDescriptionMd(): string {
      const md = new MarkdownIt()
      return md.render(this.eventDescription)
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

    async downloadImage() {

      if(!this.featureImageUrl){
        alert('Please add an image to the poster!');
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
      downloadLink.download = `${this.eventTitle}.jpg`
      downloadLink.click()
      this.isDownloading = false
    },
    
    async downloadPDF() {

      if(!this.featureImageUrl){
        alert('Please add an image to the poster!');
        return;
      }

      this.isDownloading = true
      const url = await domtoimage.toJpeg(
        document.getElementById('poster-preview')
      )
      const doc = new jsPDF(); // http://raw.githack.com/MrRio/jsPDF/master/docs/jsPDF.html
      doc.addImage(url, 0, 0, 210, 297); // http://raw.githack.com/MrRio/jsPDF/master/docs/module-addImage.html#~addImage
      doc.save(`${this.eventTitle}.pdf`);
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
  font-size: 1em;
}

@mixin justify {
  text-align: justify;
  text-align-last: justify;
  text-justify: inter-ideograph;
}

@mixin debug-borders {
  border-style: dashed;
  border-color: black;
  border-width: 0px;
}

.root {
  min-width: 600px;
  display: flex;
  flex-direction: column;
  align-items: center;
  background-color: #dddddd;

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
        .feature-image-uploader {
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
      flex-direction: row;
      justify-content: space-between;
      align-items: stretch;
      background-color: white;
      box-sizing: border-box;
      .left {
        flex-grow: 2;
        display: inline-flex;
        flex-direction: column;
        height: 100%;
        justify-content: space-between;
        align-items: stretch;
        @include debug-borders();          
        
        .feature-image {
          flex-grow: 2;
          background: #dddddd;
          background-size: cover;
          background-repeat: no-repeat;
          background-position-y: center;
          background-position-x: center;
          border-radius: 1em;
          
          // upload icon
          display: flex;
          justify-content: center;
          text-align: center;
          flex-direction: column;
          .upload {
            text-decoration: underline;
            font-weight: bold;
          }
        }

        .event-description {
          @include debug-borders();
        
          h1 {
            padding-top: 0.3em;
            padding-bottom: 0.3em;
          }
        }
      }
      .right {
        display: inline-flex;
        flex-direction: column;
        justify-content: flex-end;

        padding-left: 1em;

        .details {
          @include debug-borders();
//          display: inline-block;
          flex-grow: 1;
          justify-content: flex-end;
          display: flex;
          flex-direction: column;
        }

        .logos {
          flex-grow: 1;
          flex-direction: column;
          display: inline-flex;
          justify-content: space-between;
          position: relative;
          min-width: 8em;
          margin: 0.5em;
        }
          
        .logo {
          background-size: contain;
          background-repeat: no-repeat;
          background-position-y: center;
          background-position-x: center;
          flex-grow: 1;
        }
        
        #ammanvms {
          background-image: url(~assets/logo-square.svg);
        }
        #council {
          background-image: url(~assets/logo-cwmaman-500x500.png);
        }
      
      }

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
      }
    } /* end of poster preview */
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
