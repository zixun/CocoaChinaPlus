/**
 * Created by sunqi on 15-7-16.
 */
/**
 * @author takahiro / https://github.com/takahirox
 *
 * This loader loads and parses PMD and VMD binary files
 * then creates mesh for Three.js.
 *
 * PMD is a model data format and VMD is a motion data format
 * used in MMD(Miku Miku Dance).
 *
 * MMD is a 3D CG animation tool which is popular in Japan.
 *
 *
 * MMD official site
 *  http://www.geocities.jp/higuchuu4/index_e.htm
 *
 * PMD, VMD format
 *  http://blog.goo.ne.jp/torisu_tetosuki/e/209ad341d3ece2b1b4df24abf619d6e4
 *
 * PMX format
 *  http://www18.ocn.ne.jp/~atrenas/MMD/step_0002.html
 *
 * Model data requirements
 *  convert .tga files to .png files if exist. (Should I use THREE.TGALoader?)
 *
 * TODO
 *  pmx format support.
 *  multi vmd files support.
 *  edge(outline) support.
 *  culling support.
 *  Shift_jis strings support.
 *  toon(cel) shadering support.
 *  sphere mapping support.
 *  physics support.
 *  camera motion in vmd support.
 *  light motion in vmd support.
 */

THREE.MMDLoader = function ( showStatus, manager ) {

    THREE.Loader.call( this, showStatus );
    this.manager = ( manager !== undefined ) ? manager : THREE.DefaultLoadingManager;

};

THREE.MMDLoader.prototype = Object.create( THREE.Loader.prototype );
THREE.MMDLoader.prototype.constructor = THREE.MMDLoader;

THREE.MMDLoader.prototype.load = function ( pmdUrl, vmdUrl, callback, onProgress, onError ) {

    var texturePath = this.extractUrlBase( pmdUrl );
    this.loadPmdFile( pmdUrl, vmdUrl, texturePath, callback, onProgress, onError );

};

THREE.MMDLoader.prototype.loadFileAsBuffer = function ( url, onLoad, onProgress, onError ) {

    var loader = new THREE.XHRLoader( this.manager );
    loader.setCrossOrigin( this.crossOrigin );
    loader.setResponseType( 'arraybuffer' );
    loader.load( url, function ( buffer ) {

        onLoad( buffer );

    }, onProgress, onError );

};

THREE.MMDLoader.prototype.loadPmdFile = function ( pmdUrl, vmdUrl, texturePath, callback, onProgress, onError ) {

    var scope = this;

    this.loadFileAsBuffer( pmdUrl, function ( buffer ) {

        scope.loadVmdFile( buffer, vmdUrl, texturePath, callback, onProgress, onError );

    }, onProgress, onError );

};

THREE.MMDLoader.prototype.loadVmdFile = function ( pmdBuffer, vmdUrl, texturePath, callback, onProgress, onError ) {

    var scope = this;

    if ( ! vmdUrl ) {

        scope.parse( pmdBuffer, null, texturePath, callBack );
        return;

    }

    this.loadFileAsBuffer( vmdUrl, function ( buffer ) {

        scope.parse( pmdBuffer, buffer, texturePath, callback );

    }, onProgress, onError );

};

THREE.MMDLoader.prototype.parse = function ( pmdBuffer, vmdBuffer, texturePath, callback ) {

    var pmd = this.parsePmd( pmdBuffer );
    var vmd = vmdBuffer !== null ? this.parseVmd( vmdBuffer ) : null;
    var mesh = this.createMesh( pmd, vmd, texturePath );
    callback( mesh );

};

THREE.MMDLoader.prototype.parsePmd = function ( buffer ) {

    var scope = this;
    var pmd = {};
    var dv = new THREE.MMDLoader.DataView( buffer );

    pmd.metadata = {};
    pmd.metadata.format = 'pmd';

    var parseHeader = function () {

        var metadata = pmd.metadata;
        metadata.magic = dv.getChars( 3 );

        if ( metadata.magic !== 'Pmd' ) {

            throw 'PMD file magic is not Pmd, but ' + metadata.magic;

        }

        metadata.version = dv.getFloat32();
        metadata.modelName = dv.getSjisStrings( 20 );
        metadata.comment = dv.getSjisStrings( 256 );

    };

    var parseVertices = function () {

        var parseVertex = function () {

            var p = {};
            p.position = [ dv.getFloat32(), dv.getFloat32(), dv.getFloat32() ];
            p.normal = [ dv.getFloat32(), dv.getFloat32(), dv.getFloat32() ];
            p.uv = [ dv.getFloat32(), dv.getFloat32() ];
            p.skinIndices = [ dv.getUint16(), dv.getUint16() ];
            p.skinWeight = dv.getUint8();
            p.edgeFlag = dv.getUint8();
            return p;

        };

        var metadata = pmd.metadata;
        metadata.vertexCount = dv.getUint32();

        pmd.vertices = [];

        for ( var i = 0; i < metadata.vertexCount; i++ ) {

            pmd.vertices.push( parseVertex() );

        }

    };

    var parseFaces = function () {

        var parseFace = function () {

            var p = {};
            p.indices = [ dv.getUint16(), dv.getUint16(), dv.getUint16() ];
            return p;

        };

        var metadata = pmd.metadata;
        metadata.faceCount = dv.getUint32() / 3;

        pmd.faces = [];

        for ( var i = 0; i < metadata.faceCount; i++ ) {

            pmd.faces.push( parseFace() );

        }

    };

    var parseMaterials = function () {

        var parseMaterial = function () {

            var p = {};
            p.diffuse = [ dv.getFloat32(), dv.getFloat32(), dv.getFloat32(), dv.getFloat32() ];
            p.shiness = dv.getFloat32();
            p.specular = [ dv.getFloat32(), dv.getFloat32(), dv.getFloat32() ];
            p.emissive = [ dv.getFloat32(), dv.getFloat32(), dv.getFloat32() ];
            p.toonIndex = dv.getUint8();
            p.edgeFlag = dv.getUint8();
            p.faceCount = dv.getUint32() / 3;
            p.fileName = dv.getChars( 20 );
            return p;

        };

        var metadata = pmd.metadata;
        metadata.materialCount = dv.getUint32();

        pmd.materials = [];

        for ( var i = 0; i < metadata.materialCount; i++ ) {

            pmd.materials.push( parseMaterial() );

        }

    };

    var parseBones = function () {

        var parseBone = function () {

            var p = {};
            p.name = dv.getSjisStrings( 20 );
            p.parentIndex = dv.getUint16();
            p.tailIndex = dv.getUint16();
            p.type = dv.getUint8();
            p.ikIndex = dv.getUint16();
            p.position = [ dv.getFloat32(), dv.getFloat32(), dv.getFloat32() ];
            return p;

        };

        var metadata = pmd.metadata;
        metadata.boneCount = dv.getUint16();

        pmd.bones = [];

        for ( var i = 0; i < metadata.boneCount; i++ ) {

            pmd.bones.push( parseBone() );

        }

    };

    var parseIks = function () {

        var parseIk = function () {

            var p = {};
            p.target = dv.getUint16();
            p.effector = dv.getUint16();
            p.linkCount = dv.getUint8();
            p.iteration = dv.getUint16();
            p.maxAngle = dv.getFloat32();

            p.links = [];
            for ( var i = 0; i < p.linkCount; i++ ) {

                p.links.push( dv.getUint16() );

            }

            return p;

        };

        var metadata = pmd.metadata;
        metadata.ikCount = dv.getUint16();

        pmd.iks = [];

        for ( var i = 0; i < metadata.ikCount; i++ ) {

            pmd.iks.push( parseIk() );

        }

    };

    var parseMorphs = function () {

        var parseMorph = function () {

            var p = {};
            p.name = dv.getSjisStrings( 20 );
            p.vertexCount = dv.getUint32();
            p.type = dv.getUint8();

            p.vertices = [];
            for ( var i = 0; i < p.vertexCount; i++ ) {

                p.vertices.push( {
                    index: dv.getUint32(),
                    position: [ dv.getFloat32(), dv.getFloat32(), dv.getFloat32() ]
                } ) ;

            }

            return p;

        };

        var metadata = pmd.metadata;
        metadata.morphCount = dv.getUint16();

        pmd.morphs = [];

        for ( var i = 0; i < metadata.morphCount; i++ ) {

            pmd.morphs.push( parseMorph() );

        }


    };

    parseHeader();
    parseVertices();
    parseFaces();
    parseMaterials();
    parseBones();
    parseIks();
    parseMorphs();

    return pmd;

};

// Not yet
THREE.MMDLoader.prototype.parsePmx = function ( buffer ) {

    var scope = this;
    var pmx = {};
    var dv = new THREE.MMDLoader.DataView( buffer );

    pmx.metadata = {};
    pmd.metadata.format = 'pmx';

    return pmx;

};

THREE.MMDLoader.prototype.parseVmd = function ( buffer ) {

    var scope = this;
    var vmd = {};
    var dv = new THREE.MMDLoader.DataView( buffer );

    vmd.metadata = {};

    var parseHeader = function () {

        var metadata = vmd.metadata;
        metadata.magic = dv.getChars( 30 );

        if ( metadata.magic !== 'Vocaloid Motion Data 0002' ) {

            throw 'VMD file magic is not Vocaloid Motion Data 0002, but ' + metadata.magic;

        }

        metadata.name = dv.getSjisStrings( 20 );

    };

    var parseMotions = function () {

        var parseMotion = function () {

            var p = {};
            p.boneName = dv.getSjisStrings( 15 );
            p.frameNum = dv.getUint32();
            p.position = [ dv.getFloat32(), dv.getFloat32(), dv.getFloat32() ];
            p.rotation = [ dv.getFloat32(), dv.getFloat32(), dv.getFloat32(), dv.getFloat32() ];

            p.interpolation = [];
            for ( var i = 0; i < 64; i++ ) {

                p.interpolation.push( dv.getUint8() );

            }

            return p;

        };

        var metadata = vmd.metadata;
        metadata.motionCount = dv.getUint32();

        vmd.motions = [];
        for ( var i = 0; i < metadata.motionCount; i++ ) {

            vmd.motions.push( parseMotion() );

        }

    };

    var parseMorphs = function () {

        var parseMorph = function () {

            var p = {};
            p.morphName = dv.getSjisStrings( 15 );
            p.frameNum = dv.getUint32();
            p.weight = dv.getFloat32();
            return p;

        };

        var metadata = vmd.metadata;
        metadata.morphCount = dv.getUint32();

        vmd.morphs = [];
        for ( var i = 0; i < metadata.morphCount; i++ ) {

            vmd.morphs.push( parseMorph() );

        }

    };

    parseHeader();
    parseMotions();
    parseMorphs();

    return vmd;

};

// maybe better to create json and then use JSONLoader...
THREE.MMDLoader.prototype.createMesh = function ( pmd, vmd, texturePath, onProgress, onError ) {

    var scope = this;
    var geometry = new THREE.Geometry();
    var material = new THREE.MeshFaceMaterial();

    var leftToRight = function() {

        var convertVector = function ( v ) {

            v[ 2 ] = -v[ 2 ];

        };

        var convertQuaternion = function ( q ) {

            q[ 0 ] = -q[ 0 ];
            q[ 1 ] = -q[ 1 ];

        };

        var convertIndexOrder = function ( p ) {

            var tmp = p[ 2 ];
            p[ 2 ] = p[ 0 ];
            p[ 0 ] = tmp;

        };

        for ( var i = 0; i < pmd.metadata.vertexCount; i++ ) {

            convertVector( pmd.vertices[ i ].position );
            convertVector( pmd.vertices[ i ].normal );

        }

        for ( var i = 0; i < pmd.metadata.faceCount; i++ ) {

            convertIndexOrder( pmd.faces[ i ].indices );

        }

        for ( var i = 0; i < pmd.metadata.boneCount; i++ ) {

            convertVector( pmd.bones[ i ].position );

        }

        for ( var i = 0; i < pmd.metadata.morphCount; i++ ) {

            var m = pmd.morphs[ i ];

            for( var j = 0; j < m.vertexCount; j++ ) {

                convertVector( m.vertices[ j ].position );

            }

        }

        for ( var i = 0; i < vmd.metadata.motionCount; i++ ) {

            convertVector( vmd.motions[ i ].position );
            convertQuaternion( vmd.motions[ i ].rotation );

        }

    };

    var initVartices = function () {

        for ( var i = 0; i < pmd.metadata.vertexCount; i++ ) {

            geometry.vertices.push(
                new THREE.Vector3(
                    pmd.vertices[ i ].position[ 0 ],
                    pmd.vertices[ i ].position[ 1 ],
                    pmd.vertices[ i ].position[ 2 ]
                )
            );

            geometry.skinIndices.push(
                new THREE.Vector4(
                    pmd.vertices[ i ].skinIndices[ 0 ],
                    pmd.vertices[ i ].skinIndices[ 1 ],
                    0.0,
                    0.0
                )
            );

            geometry.skinWeights.push(
                new THREE.Vector4(
                    pmd.vertices[ i ].skinWeight / 100,
                    (100 - pmd.vertices[ i ].skinWeight) / 100,
                    0.0,
                    0.0
                )
            );

        }

    };

    var initFaces = function () {

        for ( var i = 0; i < pmd.metadata.faceCount; i++ ) {

            geometry.faces.push(
                new THREE.Face3(
                    pmd.faces[ i ].indices[ 0 ],
                    pmd.faces[ i ].indices[ 1 ],
                    pmd.faces[ i ].indices[ 2 ]
                )
            );

            for ( var j = 0; j < 3; j++ ) {

                geometry.faces[ i ].vertexNormals[ j ] =
                    new THREE.Vector3(
                        pmd.vertices[ pmd.faces[ i ].indices[ j ] ].normal[ 0 ],
                        pmd.vertices[ pmd.faces[ i ].indices[ j ] ].normal[ 1 ],
                        pmd.vertices[ pmd.faces[ i ].indices[ j ] ].normal[ 2 ]
                    );

            }

        }

    };

    var initBones = function () {

        var bones = [];

        for( var i = 0; i < pmd.metadata.boneCount; i++ ) {

            var bone = {};
            var b = pmd.bones[ i ];

            bone.parent = ( b.parentIndex === 0xFFFF ) ? -1 : b.parentIndex;
            bone.name = b.name;
            bone.pos = [ b.position[ 0 ], b.position[ 1 ], b.position[ 2 ] ];
            bone.rotq = [ 0, 0, 0, 1 ];
            bone.scl = [ 1, 1, 1 ];

            if ( bone.parent !== -1 ) {

                bone.pos[ 0 ] -= pmd.bones[ bone.parent ].position[ 0 ];
                bone.pos[ 1 ] -= pmd.bones[ bone.parent ].position[ 1 ];
                bone.pos[ 2 ] -= pmd.bones[ bone.parent ].position[ 2 ];

            }

            bones.push( bone );

        }

        geometry.bones = bones;

    };

    var initIKs = function () {

        var iks = [];

        for( var i = 0; i < pmd.metadata.ikCount; i++ ) {

            var ik = pmd.iks[i];
            var param = {};

            param.target = ik.target;
            param.effector = ik.effector;
            param.iteration = ik.iteration;
            param.maxAngle = ik.maxAngle * 4;
            param.links = [];

            for ( var j = 0; j < ik.links.length; j++ ) {

                var link = {};
                link.index = ik.links[ j ];

                // '0x820xd00x820xb4' = 'ひざ'
                // see THREE.MMDLoader.DataVie.getSjisStrings()
                if ( pmd.bones[ link.index ].name.indexOf( '0x820xd00x820xb4' ) >= 0 ) {

                    link.limitation = new THREE.Vector3( 1.0, 0.0, 0.0 );

                }

                param.links.push( link );

            }

            iks.push( param );

        }

        geometry.iks = iks;

    };

    var initMorphs = function () {

        for ( var i = 0; i < pmd.metadata.morphCount; i++ ) {

            var m = pmd.morphs[ i ];
            var params = {};

            params.name = m.name;
            params.vertices = [];

            for( var j = 0; j < pmd.metadata.vertexCount; j++ ) {

                params.vertices[ j ] = new THREE.Vector3( 0, 0, 0 );
                params.vertices[ j ].x = geometry.vertices[ j ].x;
                params.vertices[ j ].y = geometry.vertices[ j ].y;
                params.vertices[ j ].z = geometry.vertices[ j ].z;

            }

            if ( i !== 0 ) {

                for( var j = 0; j < m.vertexCount; j++ ) {

                    var v = m.vertices[ j ];
                    var index = pmd.morphs[ 0 ].vertices[ v.index ].index;
                    params.vertices[ index ].x += v.position[ 0 ];
                    params.vertices[ index ].y += v.position[ 1 ];
                    params.vertices[ index ].z += v.position[ 2 ];

                }

            }

            geometry.morphTargets.push( params );

        }

    };

    var initMaterials = function () {

        var offset = 0;
        var materialParams = [];

        for ( var i = 1; i < pmd.metadata.materialCount; i++ ) {

            geometry.faceVertexUvs.push( [] );

        }

        for ( var i = 0; i < pmd.metadata.materialCount; i++ ) {

            var m = pmd.materials[ i ];
            var params = {};

            for ( var j = 0; j < m.faceCount; j++ ) {

                geometry.faces[ offset ].materialIndex = i;

                var uvs = [];

                for ( var k = 0; k < 3; k++ ) {

                    var v = pmd.vertices[ pmd.faces[ offset ].indices[ k ] ];
                    uvs.push( new THREE.Vector2( v.uv[ 0 ], v.uv[ 1 ] ) );

                }

                geometry.faceVertexUvs[ 0 ].push( uvs );

                offset++;

            }

            params.shading = 'phong';
            params.colorDiffuse = [ m.diffuse[ 0 ], m.diffuse[ 1 ], m.diffuse[ 2 ] ];
            params.opacity = m.diffuse[ 3 ];
            params.colorSpecular = [ m.specular[ 0 ], m.specular[ 1 ], m.specular[ 2 ] ];
            params.specularCoef = m.shiness;

            // temporal workaround
            // TODO: implement correctly
            params.doubleSided = true;

            if( m.fileName ) {

                var fileName = m.fileName;

                // temporal workaround, use .png instead of .tga
                // TODO: tga file support
                if ( fileName.indexOf( '.tga' ) ) {

                    fileName = fileName.replace( '.tga', '.png' );

                }

                // temporal workaround, disable sphere mapping so far
                // TODO: sphere mapping support
                var index;

                if( ( index = fileName.lastIndexOf( '*' ) ) >= 0 ) {

                    fileName = fileName.slice( index + 1 );

                }

                if( ( index = fileName.lastIndexOf( '+' ) ) >= 0 ) {

                    fileName = fileName.slice( index + 1 );

                }

                params.mapDiffuse = fileName;

            } else {

                params.colorEmissive = [ m.emissive[ 0 ], m.emissive[ 1 ], m.emissive[ 2 ] ];

            }

            materialParams.push( params );

        }

        var materials = scope.initMaterials( materialParams, texturePath );

        for ( var i = 0; i < materials.length; i++ ) {

            var m = materials[ i ];

            if ( m.map ) {

                m.map.flipY = false;

            }

            m.skinning = true;
            m.morphTargets = true;
            material.materials.push( m );

        }

    };

    var initMotionAnimations = function () {

        var orderedMotions = [];
        var boneTable = {};

        for ( var i = 0; i < pmd.metadata.boneCount; i++ ) {

            var b = pmd.bones[ i ];
            boneTable[ b.name ] = i;
            orderedMotions[ i ] = [];

        }

        for ( var i = 0; i < vmd.motions.length; i++ ) {

            var m = vmd.motions[ i ];
            var num = boneTable[ m.boneName ];

            if ( num === undefined )
                continue;

            orderedMotions[ num ].push( m );

        }

        for ( var i = 0; i < orderedMotions.length; i++ ) {

            orderedMotions[ i ].sort( function ( a, b ) {

                return a.frameNum - b.frameNum;

            } ) ;

        }

        var animation = {
            name: 'Action',
            fps: 30,
            length: 0.0,
            hierarchy: []
        };

        for ( var i = 0; i < geometry.bones.length; i++ ) {

            animation.hierarchy.push(
                {
                    parent: geometry.bones[ i ].parent,
                    keys: []
                }
            );

        }

        var maxTime = 0.0;

        for ( var i = 0; i < orderedMotions.length; i++ ) {

            var array = orderedMotions[ i ];

            for ( var j = 0; j < array.length; j++ ) {

                var t = array[ j ].frameNum / 30;
                var p = array[ j ].position;
                var r = array[ j ].rotation;

                animation.hierarchy[ i ].keys.push(
                    {
                        time: t,
                        pos: [ geometry.bones[ i ].pos[ 0 ] + p[ 0 ],
                            geometry.bones[ i ].pos[ 1 ] + p[ 1 ],
                            geometry.bones[ i ].pos[ 2 ] + p[ 2 ] ],
                        rot: [ r[ 0 ], r[ 1 ], r[ 2 ], r[ 3 ] ],
                        scl: [ 1, 1, 1 ]
                    }
                );

                if ( t > maxTime )
                    maxTime = t;

            }

        }

        // add 2 secs as afterglow
        maxTime += 2.0;
        animation.length = maxTime;

        for ( var i = 0; i < orderedMotions.length; i++ ) {

            var keys = animation.hierarchy[ i ].keys;

            if ( keys.length === 0 ) {

                keys.push( { time: 0.0,
                    pos: [ geometry.bones[ i ].pos[ 0 ],
                        geometry.bones[ i ].pos[ 1 ],
                        geometry.bones[ i ].pos[ 2 ] ],
                    rot: [ 0, 0, 0, 1 ],
                    scl: [ 1, 1, 1 ]
                } );

            }

            var k = keys[ 0 ];

            if ( k.time !== 0.0 ) {

                keys.unshift( { time: 0.0,
                    pos: [ k.pos[ 0 ], k.pos[ 1 ], k.pos[ 2 ] ],
                    rot: [ k.rot[ 0 ], k.rot[ 1 ], k.rot[ 2 ], k.rot[ 3 ] ],
                    scl: [ 1, 1, 1 ]
                } );

            }

            k = keys[ keys.length - 1 ];

            if ( k.time < maxTime ) {

                keys.push( { time: maxTime,
                    pos: [ k.pos[ 0 ], k.pos[ 1 ], k.pos[ 2 ] ],
                    rot: [ k.rot[ 0 ], k.rot[ 1 ], k.rot[ 2 ], k.rot[ 3 ] ],
                    scl: [ 1, 1, 1 ]
                } );

            }

        }

        geometry.animation = animation;

    };

    var initMorphAnimations = function () {

        var orderedMorphs = [];
        var morphTable = {}

        for ( var i = 0; i < pmd.metadata.morphCount; i++ ) {

            var m = pmd.morphs[ i ];
            morphTable[ m.name ] = i;
            orderedMorphs[ i ] = [];

        }

        for ( var i = 0; i < vmd.morphs.length; i++ ) {

            var m = vmd.morphs[ i ];
            var num = morphTable[ m.morphName ];

            if ( num === undefined )
                continue;

            orderedMorphs[ num ].push( m );

        }

        for ( var i = 0; i < orderedMorphs.length; i++ ) {

            orderedMorphs[ i ].sort( function ( a, b ) {

                return a.frameNum - b.frameNum;

            } ) ;

        }

        var morphAnimation = {
            fps: 30,
            length: 0.0,
            hierarchy: []
        };

        for ( var i = 0; i < pmd.metadata.morphCount; i++ ) {

            morphAnimation.hierarchy.push( { keys: [] } );

        }

        var maxTime = 0.0;

        for ( var i = 0; i < orderedMorphs.length; i++ ) {

            var array = orderedMorphs[ i ];

            for ( var j = 0; j < array.length; j++ ) {

                var t = array[ j ].frameNum / 30;
                var w = array[ j ].weight;

                morphAnimation.hierarchy[ i ].keys.push( { time: t, weight: w } );

                if ( t > maxTime )
                    maxTime = t;

            }

        }

        // add 2 secs as afterglow
        maxTime += 2.0;

        // use animation's length if exists. animation is master.
        maxTime = ( geometry.animation !== undefined &&
            geometry.animation.length > 0.0 )
            ? geometry.animation.length : maxTime;
        morphAnimation.length = maxTime;

        for ( var i = 0; i < orderedMorphs.length; i++ ) {

            var keys = morphAnimation.hierarchy[ i ].keys;

            if ( keys.length === 0 ) {

                keys.push( { time: 0.0, weight: 0.0 } );

            }

            var k = keys[ 0 ];

            if ( k.time !== 0.0 ) {

                keys.unshift( { time: 0.0, weight: k.weight } );

            }

            k = keys[ keys.length - 1 ];

            if ( k.time < maxTime ) {

                keys.push( { time: maxTime, weight: k.weight } );

            }

        }

        geometry.morphAnimation = morphAnimation;

    };

    leftToRight();
    initVartices();
    initFaces();
    initBones();
    initIKs();
    initMorphs();
    initMaterials();

    if ( vmd !== null ) {

        initMotionAnimations();
        initMorphAnimations();

    }

    geometry.computeFaceNormals();
    geometry.verticesNeedUpdate = true;
    geometry.normalsNeedUpdate = true;
    geometry.uvsNeedUpdate = true;

    var mesh = new THREE.SkinnedMesh( geometry, material );
    return mesh;

};

THREE.MMDLoader.DataView = function ( buffer, littleEndian ) {

    this.dv = new DataView( buffer );
    this.offset = 0;
    this.littleEndian = ( littleEndian !== undefined ) ? littleEndian : true;

};

THREE.MMDLoader.DataView.prototype = {

    constructor: THREE.MMDLoader.DataView,

    getInt8: function () {

        var value = this.dv.getInt8( this.offset );
        this.offset += 1;
        return value;

    },

    getUint8: function () {

        var value = this.dv.getUint8( this.offset );
        this.offset += 1;
        return value;

    },

    getInt16: function () {

        var value = this.dv.getInt16( this.offset, this.littleEndian );
        this.offset += 2;
        return value;

    },

    getUint16: function () {

        var value = this.dv.getUint16( this.offset, this.littleEndian );
        this.offset += 2;
        return value;

    },

    getInt32: function () {

        var value = this.dv.getInt32( this.offset, this.littleEndian );
        this.offset += 4;
        return value;

    },

    getUint32: function () {

        var value = this.dv.getUint32( this.offset, this.littleEndian );
        this.offset += 4;
        return value;

    },

    getFloat32: function () {
        var value = this.dv.getFloat32( this.offset, this.littleEndian );
        this.offset += 4;
        return value;

    },

    getFloat64: function () {

        var value = this.dv.getFloat64( this.offset, this.littleEndian );
        this.offset += 8;
        return value;

    },

    getChars: function ( size ) {

        var str = '';

        while ( size > 0 ) {

            var value = this.getUint8();
            size--;

            if( value === 0 )
                break;

            str += String.fromCharCode( value );

        }

        while ( size > 0 ) {

            this.getUint8();
            size--;

        }

        return str;

    },

    // using temporal workaround because Shift_JIS binary -> utf conversion isn't so easy.
    // Shift_JIS binary will be converted to hex strings with prefix '0x' on each byte.
    // for example Shift_JIS 'あいうえお' will be '0x82x0xa00x820xa20x800xa40x820xa60x820xa8'.
    // functions which handle Shift_JIS data (ex: bone name check) need to know this trick.
    // TODO: Shift_JIS support (by using http://imaya.blog.jp/archives/6368510.html)
    getSjisStrings: function ( size ) {

        var str = '';

        while ( size > 0 ) {

            var value = this.getUint8();
            size--;

            if ( value === 0 )
                break;

            str += '0x' + ( '0' + value.toString( 16 ) ).substr( -2 );

        }

        while ( size > 0 ) {

            this.getUint8();
            size--;

        }

        return str;

    }

};

