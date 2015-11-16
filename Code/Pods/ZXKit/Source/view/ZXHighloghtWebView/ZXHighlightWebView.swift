//
//  ZXHighlightWebView.swift
//  CocoaChinaPlus
//
//  Created by user on 15/11/8.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import MBProgressHUD


public enum ZXHighlightStyle : String {
    case Agate = "agate"
    case Androidstudio = "androidstudio"
    case Arta = "arta"
    case Ascetic = "ascetic"
    case AtelierCaveDark = "atelier-cave.dark"
    case AtelierCaveLight = "atelier-cave.light"
    case AtelierDuneDark = "atelier-dune.dark"
    case AtelierDuneLight = "atelier-dune.light"
    case AtelierEstuaryDark = "atelier-estuary.dark"
    case AtelierEstuaryLight = "atelier-estuary.light"
    case AtelierForestDark = "atelier-forest.dark"
    case AtelierForestLight = "atelier-forest.light"
    case AtelierHeathDark = "atelier-heath.dark"
    case AtelierHeathLight = "atelier-heath.light"
    case AtelierLakesideDark = "atelier-lakeside.dark"
    case AtelierLakesideLight = "atelier-lakeside.light"
    case AtelierPlateauDark = "atelier-plateau.dark"
    case AtelierPlateauLight = "atelier-plateau.light"
    case AtelierSavannaDark = "atelier-savanna.dark"
    case AtelierSavannaLight = "atelier-savanna.light"
    case AtelierSeasideDark = "atelier-seaside.dark"
    case AtelierSeasideLight = "atelier-seaside.light"
    case AtelierSulphurpoolDark = "atelier-sulphurpool.dark"
    case AtelierSulphurpoolLight = "atelier-sulphurpool.light"
    case BrownPaper = "brown_paper"
    case CodepenEmbed = "codepen-embed"
    case ColorBrewer = "color-brewer"
    case Dark = "dark"
    case Darkula = "darkula"
    case Default = "default"
    case Docco = "docco"
    case Far = "far"
    case Foundation = "foundation"
    case GithubGist = "github-gist"
    case Github = "github"
    case Googlecode = "googlecode"
    case Grayscale = "grayscale"
    case Hopscotch = "hopscotch"
    case Hybrid = "hybrid"
    case Idea = "idea"
    case IrBlack = "ir_black"
    case KimbieDark = "kimbie.dark"
    case KimbieLight = "kimbie.light"
    case Magula = "magula"
    case MonoBlue = "mono-blue"
    case Monokai = "monokai"
    case MonokaiSublime = "monokai_sublime"
    case Obsidian = "obsidian"
    case ParaisoDark = "paraiso.dark"
    case ParaisoLight = "paraiso.light"
    case Pojoaque = "pojoaque"
    case Railscasts = "railscasts"
    case Rainbow = "rainbow"
    case SchoolBook = "school_book"
    case SolarizedDark = "solarized_dark"
    case SolarizedLight = "solarized_light"
    case Sunburst = "sunburst"
    case TomorrowNightBlue = "tomorrow-night-blue"
    case TomorrowNightBright = "tomorrow-night-bright"
    case TomorrowNightEighties = "tomorrow-night-eighties"
    case TomorrowNight = "tomorrow-night"
    case Tomorrow = "tomorrow"
    case VS = "vs"
    case Xcode = "xcode"
    case Zenburn = "zenburn"
    
    func css() -> String {
        return self.rawValue + ".css"
    }
}


/// 代码高亮WebView
public class ZXHighlightWebView: UIWebView {
    
    private let baseURL = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath)
    
    public var hud:MBProgressHUD!
    
    override public init(frame: CGRect) {
        
        super.init(frame: frame)
        self.delegate = self
        self.backgroundColor = UIColor.clearColor()
        self.opaque = false
        self.hud = MBProgressHUD.showHUDAddedTo(self, animated: true)
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func loadHTMLString(string: String) {
        println(self.baseURL)
        println(NSBundle.mainBundle().privateFrameworksPath)
        self.loadHTMLString(string, baseURL: self.baseURL)
    }
    
    //MARK: override
    override public func loadHTMLString(string: String, baseURL: NSURL?) {
        var html = string
        html = html.stringByReplacingOccurrencesOfString("<p><code>", withString: "<pre><code>")
        html = html.stringByReplacingOccurrencesOfString("<pre><code>\n", withString: "<pre><code>")
        html = html.stringByReplacingOccurrencesOfString("</code></p>", withString: "</code></pre>")
        
        html = html.stringByInsertString(highlightStyleString(), beforeOccurrencesOfString: "</head>")
        super.loadHTMLString(html, baseURL: self.baseURL)
        
        //由于有的时候加载图片导致HUD不删除，这里添加一个7秒的监听，7秒自动删除
        self.hud.hide(true, afterDelay: 7)
    }
    
    
    private func highlightStyleString() -> String {
        //TODO:路径问题后续优化
        let arta_css_path = ("Frameworks/ZXKit.framework/resource.bundle/" + ZXHighlightStyle.Arta.css() )
        
        let result = "<link rel='stylesheet' href='\(arta_css_path)'>\n" +
            "<script src='Frameworks/ZXKit.framework/resource.bundle/highlight.pack.js'></script>\n" +
        "<script>hljs.initHighlightingOnLoad();</script>"
        
        return result;
    }
    
    
    
}

//MARK: - UIWebViewDelegate
extension ZXHighlightWebView:UIWebViewDelegate {
    public func webViewDidFinishLoad(webView: UIWebView) {
        self.hud.hide(true)
        MBProgressHUD.hideHUDForView(self, animated: true)
    }
    
    public func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.hud.hide(true)
        MBProgressHUD.hideHUDForView(self, animated: true)
    }
}