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
            <el-tab-pane label="Images">
              <el-form-item label="Layout" class="layout">
                <input type="radio" value="1" id="layout-1" v-model="layout" class="choice">
                <label for="layout-1"><img src="~assets/layout-1.svg" v-bind:class="{ selected: layout1selected }" /></label>
                <input type="radio" value="2" id="layout-2" v-model="layout" class="choice">
                <label for="layout-2"><img src="~assets/layout-2.svg" v-bind:class="{ selected: layout2selected }" /></label>
                <input type="radio" value="3" id="layout-3" v-model="layout" class="choice">
                <label for="layout-3"><img src="~assets/layout-3.svg" v-bind:class="{ selected: layout3selected }" /></label>
                <input type="radio" value="4" id="layout-4" v-model="layout" class="choice">
                <label for="layout-4"><img src="~assets/layout-4.svg" v-bind:class="{ selected: layout4selected }"/></label>
              </el-form-item>
              <el-form-item label="Image ↖ Upload">
                <el-upload
                  action="#"
                  :show-file-list="false"
                  :on-change="updateFeatureImage1"
                  :auto-upload="false"
                  accept="image/*" >
                  <img
                    v-if="featureImageUrl1"
                    :src="featureImageUrl1"
                    class="feature-image-uploader"
                  />
                  <i v-else class="el-icon-plus feature-image-uploader"></i>
                </el-upload>
              </el-form-item>
              <el-form-item label="Image ↗ Upload" v-show="layout4selected || layout3selected">
                <el-upload
                  action="#"
                  :show-file-list="false"
                  :on-change="updateFeatureImage3"
                  :auto-upload="false"
                  accept="image/*" >
                  <img
                    v-if="featureImageUrl3"
                    :src="featureImageUrl3"
                    class="feature-image-uploader"
                  />
                  <i v-else class="el-icon-plus feature-image-uploader"></i>
                </el-upload>
              </el-form-item>
              <el-form-item label="Image ↙ Upload" v-show="layout4selected || layout3selected || layout2selected">
                <el-upload
                  action="#"
                  :show-file-list="false"
                  :on-change="updateFeatureImage2"
                  :auto-upload="false"
                  accept="image/*" >
                  <img
                    v-if="featureImageUrl2"
                    :src="featureImageUrl2"
                    class="feature-image-uploader"
                  />
                  <i v-else class="el-icon-plus feature-image-uploader"></i>
                </el-upload>
              </el-form-item>
              <el-form-item label="Image ↘ Upload" v-show="layout4selected">
                <el-upload
                  action="#"
                  :show-file-list="false"
                  :on-change="updateFeatureImage4"
                  :auto-upload="false"
                  accept="image/*" >
                  <img
                    v-if="featureImageUrl4"
                    :src="featureImageUrl4"
                    class="feature-image-uploader"
                  />
                  <i v-else class="el-icon-plus feature-image-uploader"></i>
                </el-upload>
              </el-form-item>
            </el-tab-pane>
            <el-tab-pane label="Outline">
              <el-form-item label="Event Title">
                <el-input v-model="eventTitle" autosize type="text" />
              </el-form-item>
              <el-form-item label="Event Description (Markdown)">
                <el-input v-model="eventDescription" autosize type="textarea" />
              </el-form-item>
            </el-tab-pane>
            <el-tab-pane label="Details">
              <el-form-item label="Event Times (Markdown)">
                <el-input v-model="eventTimes" autosize type="textarea" />
              </el-form-item>
              <el-form-item label="Event Costs - fixed prize, donation (Markdown)">
                <el-input v-model="eventCost" autosize type="textarea" />
              </el-form-item>
            </el-tab-pane>
            <el-tab-pane label="Contact &  Location">
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
                Download PDF A4, A5, A6
              </el-button>
            </el-form-item>
          </el-tabs>
        </el-form>
      </div>
      <div id="poster-preview">
        <div class="left">
          <div class="feature-image-row top" v-bind:class="{ bottom: layout1selected }">
            <div class="feature-image" v-bind:style="{ backgroundImage: 'url(' + featureImageUrl1 + ')'}">
              <span class="upload" v-if="!featureImageUrl1">⇧</span>
            </div>
            <div class="feature-image with-distance-left" v-bind:style="{ backgroundImage: 'url(' + featureImageUrl3 + ')'}" v-show="layout4selected || layout3selected">
              <span class="upload" v-if="!featureImageUrl3">⇧</span>
            </div>
          </div>
          <div class="feature-image-row bottom with-distance" v-show="!layout1selected">
            <div class="feature-image" v-bind:style="{ backgroundImage: 'url(' + featureImageUrl2 + ')'}" v-show="layout4selected || layout3selected || layout2selected">
              <span class="upload" v-if="!featureImageUrl1">⇧</span>
            </div>
            <div class="feature-image with-distance-left" v-bind:style="{ backgroundImage: 'url(' + featureImageUrl4 + ')'}" v-show="layout4selected">
              <span class="upload" v-if="!featureImageUrl4">⇧</span>
            </div>
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
    var data = {
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
      featureImageUrl1: "",
      featureImageUrl2: "",
      featureImageUrl3: "",
      featureImageUrl4: "",
      eventDescription: `First: the purpose of the event and what happens

who it is for (target audience)

which skills/material to bring

which skills to learn

Please bring:
- this
- and that`,
      qr: 'https://ammanvalley.foss.wales/',
      layout: "1",
      // attributes not to save
      attributesToSave: "eventTitle eventLocation eventTimes eventCost eventContact eventDescription qr layout".split(" "),
      isDownloading: false,
    }
    const PREFILL_START = "#load=";
    if (document.location.hash.startsWith(PREFILL_START)) {
      const prefillString = unescape(document.location.hash.slice(PREFILL_START.length));
      const prefillAttributes = JSON.parse(prefillString);
      data.attributesToSave.filter(
          // @ts-ignore: TS7053
          name => typeof(prefillAttributes[name]) == typeof(data[name]) 
        ).forEach(function(name: string) {
          // @ts-ignore: TS7053
          data[name] = prefillAttributes[name];
      });
      document.location.hash = "";
    }
    return data; 
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

    layout1selected() : boolean {
      return this.layout == "1";
    },
    layout2selected() : boolean {
      return this.layout == "2";
    },
    layout3selected() : boolean {
      return this.layout == "3";
    },
    layout4selected() : boolean {
      return this.layout == "4";
    },

    featureImagesFilledIn() : boolean {
      if ((!this.featureImageUrl1) && (this.layout4selected || this.layout3selected || this.layout2selected || this.layout1selected)) return false;
      if ((!this.featureImageUrl2) && (this.layout4selected || this.layout3selected || this.layout2selected)) return false;
      if ((!this.featureImageUrl3) && (this.layout4selected || this.layout3selected)) return false;
      if ((!this.featureImageUrl4) && (this.layout4selected)) return false;
      return true;
    },
    
    loadURL() : string {
      const url = document.location + ""
      const urlWithoutHash = url.indexOf("#") == -1 ? url : url.slice(0, url.indexOf("#"))
      var data : any = {} // use type any although it is discouraged. https://stackoverflow.com/a/57192972/1320237
      var me : any = this;
      this.attributesToSave.forEach(function(name: string) {
        data[name] = me[name];
      })
      return urlWithoutHash + "#load=" + JSON.stringify(data);
    }
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
    updateFeatureImage1(file: ElUploadInternalFileDetail) {
      if (!file) return
      if (this.featureImageUrl1 !== '') URL.revokeObjectURL(this.featureImageUrl1)
      this.featureImageUrl1 = URL.createObjectURL(file.raw)
    },
    updateFeatureImage2(file: ElUploadInternalFileDetail) {
      if (!file) return
      if (this.featureImageUrl2 !== '') URL.revokeObjectURL(this.featureImageUrl2)
      this.featureImageUrl2 = URL.createObjectURL(file.raw)
    },
    updateFeatureImage3(file: ElUploadInternalFileDetail) {
      if (!file) return
      if (this.featureImageUrl3 !== '') URL.revokeObjectURL(this.featureImageUrl3)
      this.featureImageUrl3 = URL.createObjectURL(file.raw)
    },
    updateFeatureImage4(file: ElUploadInternalFileDetail) {
      if (!file) return
      if (this.featureImageUrl4 !== '') URL.revokeObjectURL(this.featureImageUrl4)
      this.featureImageUrl4 = URL.createObjectURL(file.raw)
    },
    
    async downloadImage() {

      if(!this.featureImagesFilledIn){
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

      if(!this.featureImagesFilledIn){
        alert('Please add an image to the poster!');
        return;
      }

      this.isDownloading = true
      const url = await domtoimage.toJpeg(
        document.getElementById('poster-preview')
      )
      const alias = "image";
      const doc = new jsPDF(); // http://raw.githack.com/MrRio/jsPDF/master/docs/jsPDF.html
      // http://raw.githack.com/MrRio/jsPDF/master/docs/module-addImage.html#~addImage
      // ----- create A4 image -----
      doc.addImage(url, 'JPEG', 0, 0, 210, 297, alias, "FAST");
      
      // ----- create A5 image -----
      doc.addPage();
      doc.addImage(url, 'JPEG', 210, 148.5 - 210, 148.5, 210, alias, "FAST", 90);
      doc.addImage(url, 'JPEG', 210, 148.5 + 148.5 - 210, 148.5, 210, alias, "FAST", 90);
      
      // ----- create A6 image -----
      doc.addPage();
      doc.addImage(url, 'JPEG', 0, 0, 105, 148.5, alias, "FAST");
      doc.addImage(url, 'JPEG', 105, 0, 105, 148.5, alias, "FAST");
      doc.addImage(url, 'JPEG', 0, 148.5, 105, 148.5, alias, "FAST");
      doc.addImage(url, 'JPEG', 105, 148.5, 105, 148.5, alias, "FAST");
      
      // ----- create a hyperlink to edit the poster again -----
      // for hyper links: https://stackoverflow.com/a/43398857/1320237
      doc.addPage();
      doc.text('This poster was generated with the Event Poster Generator.', 25, 25);
      doc.textWithLink('Click here to edit the poster online!', 25, 30, {url: this.loadURL});
      
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
      
      .layout {
        .choice {
          display: none;
        }
        img {
          opacity: 0.4;
        }
        img.selected {
          opacity: 1;
        }
      }
      
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
        
        .feature-image-row.top {
          border-top-left-radius: 1em;
          border-top-right-radius: 1em;
        }
        .feature-image-row.bottom {
          border-bottom-left-radius: 1em;
          border-bottom-right-radius: 1em;
        }
        .feature-image-row.with-distance {
          margin-top: 6mm;
        }
        .feature-image.with-distance-left {
          margin-left: 6mm;
        }

        .feature-image-row {
          flex-grow: 2;
          display: flex;
          flex-direction: row;
          overflow: hidden;
          
          .feature-image {
            flex-grow: 1;
            
            background: #dddddd;
            background-size: cover;
            background-repeat: no-repeat;
            background-position-y: center;
            background-position-x: center;
            
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
