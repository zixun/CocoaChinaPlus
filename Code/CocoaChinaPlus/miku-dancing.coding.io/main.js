/**
 * Created by sunqi on 16/1/6.
 */

var dancingTime = 3;
var audio = document.querySelector('#miku-music');
var battery = document.querySelector('#battery');
var play = true;
var mute = false;
var music = false;
var dance = false;
var container;

var playIndex = 0;
var playList = ['./resources/bgm.mp3'];
resetMusicSrc();

var mesh, camera, scene, renderer;

var directionalLight;

var ikSolver;

var windowWidth  = window.innerWidth;
var windowHeight = window.innerHeight;

var windowHalfX = window.innerWidth / 2;
var windowHalfY = window.innerHeight / 2;

var clock = new THREE.Clock();

init();
animate();


//重新设置音乐地址
function resetMusicSrc() {
    //随机播放
    playIndex = parseInt(Math.random() * playList.length, 10);
    audio.src = playList[playIndex];
}

function init() {

    container = document.createElement( 'div' );
    document.body.appendChild( container );

    camera = new THREE.PerspectiveCamera( 45, window.innerWidth / window.innerHeight, 1, 2000 );
    camera.position.z = 35;

    // scene

    scene = new THREE.Scene();

    camera.lookAt(scene.position);


    var ambient = new THREE.AmbientLight( 0x444444 );
    scene.add( ambient );

    directionalLight = new THREE.DirectionalLight( 0xFFEEDD );
    directionalLight.position.set( -1, 1, 1 ).normalize();
    scene.add( directionalLight );

    //加载mmd模型
    var onProgress = function ( xhr ) {
        if ( xhr.lengthComputable ) {
            var percentComplete = xhr.loaded / xhr.total * 100;
            console.log( Math.round(percentComplete, 2) + '% downloaded' );
        }
    };

    var onError = function ( xhr ) {
    };

    var loader = new THREE.MMDLoader();
    loader.load( 'models/mmd/miku_v2.pmd', 'models/mmd/wavefile_v2.vmd', function ( object ) {

        //加载完后赠送10秒播放时间
        dancingTime = 10;
        audio.play();
        //audio.loop = true;
        audio.onended = function(){
            resetMusicSrc();
            audio.onloadeddata = function(){
                audio.play();
            }
        }

        mesh = object;

        mesh.position.y = -10;
        scene.add( mesh );

        var animation = new THREE.Animation( mesh, mesh.geometry.animation );
        animation.play();

        var morphAnimation = new THREE.MorphAnimation2( mesh, mesh.geometry.morphAnimation );
        morphAnimation.play();

        ikSolver = new THREE.CCDIKSolver( mesh );

    }, onProgress, onError );

    renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true });
    renderer.setPixelRatio( window.devicePixelRatio );
    renderer.setSize( windowWidth, windowHeight );
    container.appendChild( renderer.domElement );
    window.addEventListener( 'resize', onWindowResize, false );
}

function onWindowResize() {
    windowWidth  = window.innerWidth;
    windowHeight = window.innerHeight;
    windowHalfX = window.innerWidth / 2;
    windowHalfY = window.innerHeight / 2;
    camera.aspect = windowWidth / windowHeight;
    camera.updateProjectionMatrix();
    renderer.setSize( windowWidth, windowHeight );
}

function onDocumentMouseMove( event ) {

    mouseX = ( event.clientX - windowHalfX ) / 2;
    mouseY = ( event.clientY - windowHalfY ) / 2;

}


function animate() {
    requestAnimationFrame( animate );
    var delta = clock.getDelta();
    render(delta);
}

function render(delta) {

    if( mesh && play ) {
        /*
         * 将getDelta的调用放在if判定的外部很重要哦
         * */
        //var delta = clock.getDelta();
        if(dancingTime > 0 || dance) {
            dancingTime -= delta;
            THREE.AnimationHandler.update( delta );
            battery.style.display = 'none';
            directionalLight.color.setHex(0xFFEEDD);
            if(mute){
                audio.volume = 0;
            }else{
                audio.volume = 1;
                audio.playbackRate = 1;
            }
        }else{
            THREE.AnimationHandler.update( 0.003 );
            battery.style.display = 'block';
            directionalLight.color.setHex(0xFF9999);

            if(mute){
                audio.volume = 0;
            }else if(music){
                audio.volume = 1;
                audio.playbackRate = 1;
            }else{
                audio.volume = 0.5;
                audio.playbackRate = 0.5;
            }
        }
        if( ikSolver ) {
            ikSolver.update();
        }

    }
    camera.updateProjectionMatrix();
    renderer.render( scene, camera );
}


/*
 * 交互控制模块
 * */

var Control = function(){
    this.render = renderer;
    this.camera = camera;
    this.scene = scene;
}
Control.prototype = {
    addFrame: function(s){
        var seconds = s ? s : 3;
        dancingTime = seconds;
    },
    play: function(){
        play = true;
        audio.play();
    },
    pause: function(){
        play = false;
        audio.pause();
    },
    mute: function(flag) {
        mute = flag;
    },
    music: function(flag){
        music = flag;
        audio.volume = 1;
        audio.playbackRate = 1;
    },
    dance: function(flag){
        dance = flag;
    },
    setPlayList: function(list){
        if (list.length == 0) {
            return;
        }
        playList = list;
        resetMusicSrc();
        audio.play()
    }

}
var control = new Control();
