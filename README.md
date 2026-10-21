# jiangshan-map-lzcapp

[江山时序](https://github.com/DeanChensj/jiangshan-map) 的 LazyCat LPK 打包 —— 中国历史交互地图时间轴（纯静态站）。

## 形态

- 纯静态：仓库即站点（无打包器），`scripts/validate_atlas.js` 校验数据完整性
- 版本权威：**以上游 GitHub Release tag 为准**（`v1.0.0`）
  - `build.sh` 调 GitHub Releases API 选出最高稳定 SemVer tag，按该 tag 拉源码
  - workflow 的 version job 比较上游 tag 与 `package.yml`，变化才发布
- 18 个王朝、164 幅疆域快照、地名沿革与诗词路线，共约 20 MB
- 仅 PC 平台
