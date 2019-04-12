window.onload = ()=> {
  fetch("https://api.myjson.com/bins/1430np")
  .then(resp => resp.json())
  .then(json => {
    json = json[0]
    json.userAccounts.forEach((el, index) => {
      const platforms  = document.querySelectorAll(".main-component .channel-status .platforms ul li .text")
      platforms[index].firstElementChild.innerText = el.username
      platforms[index].lastElementChild.innerText = el.platform
    })
    const facebook = json.userAccounts[0]
    const facebookElement = document.querySelector(".main-component .channel-status .facebook")
     facebookElement.querySelector(".likes .data .text h1").innerText = facebook.likes
     facebookElement.querySelector(".likes .data .visual .circle p").innerText = `+${facebook.newLikes}`
    facebookElement.querySelector(".publishes .data .text h1").innerText = facebook.publishes
    facebookElement.querySelector(".views .data h1").innerText = facebook.views
    facebookElement.querySelector(".demography .classifications .classification:nth-child(1) .text h2").innerText = facebook.demography[0].number
    facebookElement.querySelector(".demography .classifications .classification:nth-child(2) .text h2").innerText = facebook.demography[1].number
    facebook.insights.forEach((el, index) => {
      const timeline = document.querySelectorAll(".main-component .insights ul li p")
      timeline[index].innerText = el.month+ " 2017"
      document.querySelectorAll(".main-component .insights table")[index].querySelectorAll("tbody tr")
      .forEach(el => {
        facebook.insights[index].data.forEach((elm, elmIndex) => {
          el.firstElementChild.innerText = elm.day
          el.lastElementChild.innerText = elm.revenue
        })
      })
    })
    document.querySelector(".loader").style.display = "none"
   })
  .catch(e => console.log(e))


    const publishes = new Chartist.Line('.publishes .data .visual', {
      series: [
          [],
          [],
        [],
        [],
        [],
        [],
        [],
        [2, 5, 3.5, 5, 2.5, 3, 2, 1, 3, 3.5, 4, 3, 2, 1,    0.5]
      ]
    }, {
      low: 0,
      showArea: false,
      showPoint: false,
      fullWidth: true,
      axisX: {
        showGrid: false,
        showLabel: false,
        offset:0
      },
      axisY: {
        showGrid: false,
        showLabel: false,
        offset:0
      }
    });

    publishes.on('draw', function(data) {
      if(data.type === 'line' || data.type === 'area') {
        data.element.animate({
          d: {
            begin: 1000 ,
            dur: 2000,
            from: data.path.clone().scale(1, 0).translate(0, data.chartRect.height()).stringify(),
            to: data.path.clone().stringify(),
            easing: Chartist.Svg.Easing.easeOutQuint
          }
        });
      }
    });
    const views = new Chartist.Line('.views .visual', {
            labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
            series: [
                [5, 9, 7, 8, 5, 3, 5, 4],
            ],
        }, {
            low: 0,
            showArea: true,
            fullWidth: true,
            height: "250px",
            axisX: {
              offset: 20,
            },
            axisY: {
              offset: 20,
            }
        });

        views.on('draw', function(data) {
        if(data.type === 'line' || data.type === 'area') {
            data.element.animate({
            d: {
                begin: 2500 ,
                dur: 2000,
                from: data.path.clone().scale(1, 0).translate(0, data.chartRect.height()).stringify(),
                to: data.path.clone().stringify(),
                easing: Chartist.Svg.Easing.easeOutQuint
            }
            });
        }
        });

    const impressions = new Chartist.Bar('.impressions .visual', {
      labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
      series: [
        [5, 4, 3, 7, 5, 10, 3],
        [3, 2, 9, 5, 4, 6, 4]
      ]
    }, {
        seriesBarDistance: 10,
        height:"500px",
        axisY: {
            offset: 20,
            labelInterpolationFnc: function(value) {
              // Will return Mon, Tue, Wed etc. on medium screens
              return parseInt(value)
            }
        },
        low: 0,
        high: 15,


    }, [
      ['screen and (max-width: 640px)', {
        seriesBarDistance: 5,
        axisX: {
          labelInterpolationFnc: function (value) {
            return value[0];
          }
        }
      }]
    ]);


    impressions.on('draw', function(data) {
      if(data.type === 'line' || data.type === 'area') {
        data.element.animate({
          d: {
            begin: 1000 ,
            dur: 2000,
            from: data.path.clone().scale(1, 0).translate(0, data.chartRect.height()).stringify(),
            to: data.path.clone().stringify(),
            easing: Chartist.Svg.Easing.easeOutQuint
          }
        });
      }
    });

    document.querySelectorAll(".sidebar ul li").forEach(el => {
        el.onclick = ()=> {
            if(!el.classList.contains("active")) {
                Array.from(el.parentNode.children).filter(elm => elm.classList.contains("active"))[0].classList.remove("active")
                el.classList.add("active")
                const target = document.querySelector(".main-component ." + el.getAttribute("data-target"))
                const current = document.querySelector(".main-component > div.current")
                current.style.right = "-100%"
                setTimeout(()=> {
                    current.style.display = "none"
                    current.classList.remove("current")
                    target.classList.add("current")
                    target.style.display ="block"
                    setTimeout(()=> {
                        target.style.right ="0"
                    },250)
                }, 250)

            }
        }
    })

    document.querySelector(".main-component .channel-status .facebook .publishes .select > div").onclick = () => {
        const dropMenu = document.querySelector(".main-component .channel-status .facebook .publishes .select > div ul")
        if(getComputedStyle(dropMenu, null).getPropertyValue("display") === "block") {
            dropMenu.style.display = "none"
        }else if(getComputedStyle(dropMenu, null).getPropertyValue("display") === "none") {
            dropMenu.style.display = "block"
        }
    }
    document.querySelector(".main-component .channel-status .facebook .views .select > div").onclick = () => {
        const dropMenu = document.querySelector(".main-component .channel-status .facebook .views .select > div ul")
        if(getComputedStyle(dropMenu, null).getPropertyValue("display") === "block") {
            dropMenu.style.display = "none"
        }else if(getComputedStyle(dropMenu, null).getPropertyValue("display") === "none") {
            dropMenu.style.display = "block"
        }
    }

}
