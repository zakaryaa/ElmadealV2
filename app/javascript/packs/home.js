import {
  tns
} from "tiny-slider/src/tiny-slider";
import "tiny-slider/dist/tiny-slider.css";


const slider = tns({
  container: '.my-slider',
  items: 3,
  slideBy: 'page',

  gutter: 10
});