package("rendergraph")

    set_homepage("https://github.com/DragonJoker/RenderGraph/")
    set_description("Vulkan render graph management library. .")
    set_license("MIT")

    set_urls("https://github.com/DragonJoker/RenderGraph.git")
    add_versions("1.0", "61e814bb0298983eae853d9ba5386a272ebc1eb9")

    add_deps("vulkan-headers")

    add_links("RenderGraph")

    on_install("windows|x64", "macosx", "linux", function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.debug", "mode.release")
            add_requires("vulkan-headers")
            target("RenderGraph")
                set_kind("$(kind)")
                add_includedirs("include")
                add_files("source/RenderGraph/**.cpp")
                set_languages("c++20")
                if is_plat("windows") then
                    if is_kind("shared") then
                        add_defines("RenderGraph_EXPORTS")
                    else
                        add_defines("CRG_BUILD_STATIC")
                    end
                end
                add_headerfiles("include/(RenderGraph/**.hpp)")
                add_packages("vulkan-headers")
        ]])
        local configs = {}
        if package:config("shared") then 
            configs.kind = "shared"
        end
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            static void test()
            {
                crg::ResourceHandler handler;
                crg::FrameGraph graph{ handler, "test" };
            }
        ]]}, {configs = {languages = "cxx20"},
            includes = {
                "RenderGraph/FrameGraph.hpp",
                "RenderGraph/ResourceHandler.hpp"}}))
    end)
