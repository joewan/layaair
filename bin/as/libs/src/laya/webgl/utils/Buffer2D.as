package laya.webgl.utils {
	import laya.renders.Render;
	import laya.resource.Resource;
	import laya.utils.Byte;
	import laya.utils.Stat;
	import laya.webgl.shader.Shader;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.submit.Submit;
	
	/**
	 * ...
	 * @author laya
	 */
	public class Buffer2D extends Buffer {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		//Uniform
		public static const UNICOLOR:String = "UNICOLOR";
		public static const MVPMATRIX:String = "MVPMATRIX";
		public static const MATRIX1:String = "MATRIX1";
		public static const MATRIX2:String = "MATRIX2";
		public static const DIFFUSETEXTURE:String = "DIFFUSETEXTURE";
		public static const NORMALTEXTURE:String = "NORMALTEXTURE";
		public static const SPECULARTEXTURE:String = "SPECULARTEXTURE";
		public static const EMISSIVETEXTURE:String = "EMISSIVETEXTURE";
		public static const AMBIENTTEXTURE:String = "AMBIENTTEXTURE";
		public static const REFLECTTEXTURE:String = "REFLECTTEXTURE";
		public static const MATRIXARRAY0:String = "MATRIXARRAY0";
		public static const FLOAT0:String = "FLOAT0";
		public static const UVAGEX:String = "UVAGEX";
		
		public static const CAMERAPOS:String = "CAMERAPOS";
		public static const ALBEDO:String = "ALBEDO";
		public static const ALPHATESTVALUE:String = "ALPHATESTVALUE";
		
		public static const FOGCOLOR:String = "FOGCOLOR";
		public static const FOGSTART:String = "FOGSTART";
		public static const FOGRANGE:String = "FOGRANGE";
		
		public static const MATERIALAMBIENT:String = "MATERIALAMBIENT";
		public static const MATERIALDIFFUSE:String = "MATERIALDIFFUSE";
		public static const MATERIALSPECULAR:String = "MATERIALSPECULAR";
		public static const MATERIALREFLECT:String = "MATERIALREFLECT";
		
		public static const LIGHTDIRECTION:String = "LIGHTDIRECTION";
		public static const LIGHTDIRDIFFUSE:String = "LIGHTDIRDIFFUSE";
		public static const LIGHTDIRAMBIENT:String = "LIGHTDIRAMBIENT";
		public static const LIGHTDIRSPECULAR:String = "LIGHTDIRSPECULAR";
		
		public static const POINTLIGHTPOS:String = "POINTLIGHTPOS";
		public static const POINTLIGHTRANGE:String = "POINTLIGHTRANGE";
		public static const POINTLIGHTATTENUATION:String = "POINTLIGHTATTENUATION";
		public static const POINTLIGHTDIFFUSE:String = "POINTLIGHTDIFFUSE";
		public static const POINTLIGHTAMBIENT:String = "POINTLIGHTAMBIENT";
		public static const POINTLIGHTSPECULAR:String = "POINTLIGHTSPECULAR";
		
		public static const SPOTLIGHTPOS:String = "SPOTLIGHTPOS";
		public static const SPOTLIGHTDIRECTION:String = "SPOTLIGHTDIRECTION";
		public static const SPOTLIGHTSPOT:String = "SPOTLIGHTSPOT";
		public static const SPOTLIGHTRANGE:String = "SPOTLIGHTRANGE";
		public static const SPOTLIGHTATTENUATION:String = "SPOTLIGHTATTENUATION";
		public static const SPOTLIGHTDIFFUSE:String = "SPOTLIGHTDIFFUSE";
		public static const SPOTLIGHTAMBIENT:String = "SPOTLIGHTAMBIENT";
		public static const SPOTLIGHTSPECULAR:String = "SPOTLIGHTSPECULAR";
		
		//................................................................................................................
		public static const TIME:String = "TIME";
		public static const VIEWPORTSCALE:String = "VIEWPORTSCALE";
		public static const CURRENTTIME:String = "CURRENTTIME";
		public static const DURATION:String = "DURATION";
		public static const GRAVITY:String = "GRAVITY";
		public static const ENDVELOCITY:String = "ENDVELOCITY";
		//.........................................................................................................................
		
		public static const FLOAT32:int = 4;
		public static const SHORT:int = 2;
		
		public static function __int__(gl:WebGLContext):void {
			IndexBuffer2D.QuadrangleIB = IndexBuffer2D.create(WebGLContext.STATIC_DRAW);
			GlUtils.fillIBQuadrangle(IndexBuffer2D.QuadrangleIB, 16);
		}
		
		protected var _maxsize:int = 0;
		
		public var _upload:Boolean = true;
		protected var _uploadSize:int = 0;
		
		
		
		public function get bufferLength():int {
			return _buffer.byteLength;
		}
		
		public function set byteLength(value:int):void {
			if (_byteLength === value)
				return;
			value <= _buffer.byteLength || (_resizeBuffer(value * 2 + 256, true));
			_byteLength = value;
		}
		
		
		
		public function Buffer2D() {
			super();
			lock = true;
		}
		
		protected function _bufferData():void {
			_maxsize = Math.max(_maxsize, _byteLength);
			if (Stat.loopCount % 30 == 0) {
				if (_buffer.byteLength > (_maxsize + 64)) {
					memorySize = _buffer.byteLength;
					_buffer = _buffer.slice(0, _maxsize + 64);
					_checkArrayUse();
				}
				_maxsize = _byteLength;
			}
			if (_uploadSize < _buffer.byteLength) {
				_uploadSize = _buffer.byteLength;
				
				_gl.bufferData(_bufferType, _uploadSize, _bufferUsage);
				memorySize = _uploadSize;
			}
			_gl.bufferSubData(_bufferType, 0, _buffer);
		}
		
		protected function _bufferSubData(offset:int = 0, dataStart:int = 0, dataLength:int = 0):void {
			_maxsize = Math.max(_maxsize, _byteLength);
			if (Stat.loopCount % 30 == 0) {
				if (_buffer.byteLength > (_maxsize + 64)) {
					memorySize = _buffer.byteLength;
					_buffer = _buffer.slice(0, _maxsize + 64);
					_checkArrayUse();
				}
				_maxsize = _byteLength;
			}
			
			if (_uploadSize < _buffer.byteLength) {
				_uploadSize = _buffer.byteLength;
				
				_gl.bufferData(_bufferType, _uploadSize, _bufferUsage);
				memorySize = _uploadSize;
			}
			
			if (dataStart || dataLength) {
				var subBuffer:ArrayBuffer = _buffer.slice(dataStart, dataLength);
				_gl.bufferSubData(_bufferType, offset, subBuffer);
			} else {
				_gl.bufferSubData(_bufferType, offset, _buffer);
			}
		}
		
		protected function _checkArrayUse():void {
		}
		
		public function _bind_upload():Boolean {
			if (!_upload)
				return false;
			_upload = false;
			_bind();
			_bufferData();
			return true;
		}
		
		public function _bind_subUpload(offset:int = 0, dataStart:int = 0, dataLength:int = 0):Boolean {
			if (!_upload)
				return false;
			
			_upload = false;
			_bind();
			_bufferSubData(offset, dataStart, dataLength);
			return true;
		}
		
		public function _resizeBuffer(nsz:int, copy:Boolean):Buffer2D //是否修改了长度
		{
			if (nsz < _buffer.byteLength)
				return this;
			memorySize = nsz;
			if (copy && _buffer && _buffer.byteLength > 0) {
				var newbuffer:ArrayBuffer = new ArrayBuffer(nsz);
				var n:* = new Uint8Array(newbuffer);
				n.set(new Uint8Array(_buffer), 0);
				_buffer = newbuffer;
			} else
				_buffer = new ArrayBuffer(nsz);
			_checkArrayUse();
			_upload = true;
			
			return this;
		}
		
		public function append(data:*):void {
			_upload = true;
			var byteLen:int, n:*;
			byteLen = data.byteLength;
			if (data is Uint8Array) {
				_resizeBuffer(_byteLength + byteLen, true);
				n = new Uint8Array(_buffer, _byteLength);
			} else if (data is Uint16Array) {
				_resizeBuffer(_byteLength + byteLen, true);
				n = new Uint16Array(_buffer, _byteLength);
			} else if (data is Float32Array) {
				_resizeBuffer(_byteLength + byteLen, true);
				n = new Float32Array(_buffer, _byteLength);
			}
			n.set(data, 0);
			_byteLength += byteLen;
			_checkArrayUse();
		}
		
		public function getBuffer():ArrayBuffer {
			return _buffer;
		}
		
		public function setNeedUpload():void {
			_upload = true;
		}
		
		public function getNeedUpload():Boolean {
			return _upload;
		}
		
		public function upload():Boolean {
			var scuess:Boolean = _bind_upload();
			_gl.bindBuffer(_bufferType, null);
			_bindActive[_bufferType] = null;
			Shader.activeShader = null
			return scuess;
		}
		
		public function subUpload(offset:int = 0, dataStart:int = 0, dataLength:int = 0):Boolean {
			var scuess:Boolean = _bind_subUpload();
			_gl.bindBuffer(_bufferType, null);
			_bindActive[_bufferType] = null;
			Shader.activeShader = null
			return scuess;
		}
		
		override protected function detoryResource():void {
			super.detoryResource();
			_upload = true;
			_uploadSize = 0;
		}
		
		public function clear():void {
			_byteLength = 0;
			_upload = true;
		}
	}

}