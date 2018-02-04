<template>
  <div>
    <h1>About Me</h1>

    <p>
      Hello, my name is Tim Morgan. I am a full-stack web developer, hobbyist
      pilot, and all around aviation fanatic. I created this podcast to share my
      love of aviation with you, and to learn and discuss interesting topics I
      come across as I expand my aviation knowledge.
    </p>

    <img :src="image1" />

    <p>
      I hold a commercial pilot certificate with airplane single-engine land and
      sea ratings, aircraft multi-engine land rating, and instrument airplane
      rating. I currently own a 2005 Cirrus SR22 Turbo G2, and I also have
      experience in a variety of other small aircraft types.
    </p>

    <img :src="image2" />

    <p>
      I also play a variety of combat and civilian flight simulators (Digital
      Combat Simulator, Falcon BMS, Prepar3D [A2A and PMDG aircraft], and
      others).
    </p>

    <img :src="image3" />

    <p>
      This podcast was inspired by
      <a href="https://www.quora.com/profile/Tim-Morgan-5">my answers on
        Quora</a>. When I’m not coding or flying, I’m typically answering
      aviation questions on Quora. (Even when I should be doing other things,
      like paying attention to the people around me…) I take great joy in
      sharing aviation knowledge on Quora, and this podcast is another medium
      in which to do so.
    </p>
  </div>
</template>

<script>
  import Image1 from 'images/about1.jpg'
  import Image2 from 'images/about2.jpg'
  import Image3 from 'images/about3.jpg'

  export default {
    data() {
      return {
        image1: Image1,
        image2: Image2,
        image3: Image3
      }
    }
  }
</script>

<style scoped lang="scss">
  @import "../styles/vars";

  img {
    display: block;
    width: 300px;
    margin: 40px auto;
  }

  @include responsive-desktop {
    div {
      width: 540px;
      margin-left: auto;
      margin-right: auto;
    }
  }
</style>
