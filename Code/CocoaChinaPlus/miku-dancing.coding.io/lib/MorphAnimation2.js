/**
 * Created by sunqi on 15-7-16.
 */
/**
 * @author takahiro / https://github.com/takahirox
 *
 * This class is similar to THREE.Animation.
 * It controls all mesh.morphTargetInfluences parameters in each frame.
 *
 * Passed parameter is similar to THREE.Animation's as well
 * other than that hierarchy corresponds to morphTargetInfluences and
 * each key should have weight instead of pos, rot, and scl.
 *
 * TODO
 *  rename to appropriate one.
 *  consider to combine with THREE.Animation
 */

THREE.MorphAnimation2 = function ( mesh, data ) {

    this.mesh = mesh;
    this.influences = mesh.morphTargetInfluences;
    this.data = data;
    this.hierarchy = data.hierarchy;

    this.currentTime = 0;

    for ( var i = 0; i < this.hierarchy.length; i++ ) {

        this.hierarchy[ i ].currentFrame = -1;

    }

    this.isPlaying = false;
    this.loop = true;

};

THREE.MorphAnimation2.prototype = {

    constructor: THREE.MorphAnimation2,

    play: function ( startTime ) {

        this.currentTime = startTime !== undefined ? startTime : 0;
        this.isPlaying = true;
        this.reset();

        THREE.AnimationHandler.play( this );

    },

    pause: function () {

        this.isPlaying = false;

        THREE.AnimationHandler.stop( this );

    },

    reset: function () {

        for ( var i = 0; i < this.hierarchy.length; i++ ) {

            this.hierarchy[ i ].currentFrame = -1;

        }

    },

    // Note: This's for being used by THREE.AnimationHandler.update()
    resetBlendWeights: function () {
    },

    update: function ( delta ) {

        if ( this.isPlaying === false ) return;

        this.currentTime += delta;

        var duration = this.data.length;

        if ( this.currentTime > duration || this.currentTime < 0 ) {

            if ( this.loop ) {

                this.currentTime %= duration;

                if ( this.currentTime < 0 ) {

                    this.currentTime += duration;

                }

                this.reset();

            } else {

                this.stop();

            }

        }

        for ( var h = 0, hl = this.hierarchy.length; h < hl; h++ ) {

            var object = this.hierarchy[ h ];
            var keys = object.keys;
            var weight = 0.0;

            while ( object.currentFrame + 1 < keys.length &&
                this.currentTime >= keys[ object.currentFrame + 1 ].time ) {

                object.currentFrame++;

            }

            if ( object.currentFrame >= 0 ) {

                var prevKey = keys[ object.currentFrame ];
                weight = prevKey.weight;

                if ( object.currentFrame < keys.length ) {

                    var nextKey = keys[ object.currentFrame + 1 ];

                    if ( nextKey.time > prevKey.time ) {

                        var interpolation = ( this.currentTime - prevKey.time ) / ( nextKey.time - prevKey.time );
                        weight = weight * ( 1.0 - interpolation ) + nextKey.weight * interpolation;

                    }

                }

            }

            this.influences[ h ] = weight;

        }

    }

};
